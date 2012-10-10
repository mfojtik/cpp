require_relative './init.rb'

module DeltaControl
  class App < Sinatra::Base

    enable :sessions
    enable :dump_errors

    configure(:development) { set :session_secret, "123456" }

    use Rack::CommonLogger

    helpers ViewHelper
    helpers AppHelper

    # Enable flash[] messages through session
    before do
      @_flash, session[:_flash] = session[:_flash], nil if session[:_flash]
    end

    get '/' do
      return redirect(url('/login')) unless logged_in?
      redirect url('/accounts')
    end

    get '/login' do
      haml :login
    end

    get '/signup' do
      haml :signup
    end

    post '/signup' do
      return redirect(url('/signup')) if params[:password] != params[:password2]
      user = User.create(:name => params[:user], :password => params[:password])
      session['user_id'] = user.id
      redirect url('/')
    end

    get '/logout' do
      logout!
      redirect url('/login')
    end

    post '/login' do
      if user = User.first(:name => params[:user], :password => params[:password])
        flash[:success] = 'Welcome back %s!' % user.name
        session['user_id'] = user.id
        redirect url('/')
      else
        flash[:error] = 'Invalid credentials. Please try again.'
        redirect url('/login')
      end
    end

    get '/accounts' do
      @accounts = current_user.available_accounts
      haml :accounts
    end

    get '/accounts/new' do
      haml :new_account
    end

    post '/accounts' do
      account = Account.new(params[:account].merge(:created_by => current_user.id))
      current_user.accounts << account
      current_user.save
      flash[:info] = 'Account "%s" successfully created.' % params[:account][:name]
      redirect url('/accounts')
    end

    post '/accounts/:id' do
      account = current_user.own_accounts.get(params[:id])
      account.attributes = params[:account]
      account.visibility = :private if params[:account][:visibility] != 'public'
      account.save
      flash[:info] = 'Account "%s" successfully updated.' % account.name
      redirect url('/accounts')
    end

    get '/accounts/:id/edit' do
      @account = current_user.own_accounts.get(params[:id])
      haml :edit_account
    end

    get '/accounts/:id' do
      @account = current_user.available_accounts.get(params[:id])
      haml :account
    end

    get '/accounts/:id/delete' do
      account = current_user.own_accounts.first(:id => params[:id])
      flash[:info] = 'Account "%s" successfully removed.' % account.name
      account.destroy!
      redirect url('/accounts')
    end

    post '/accounts/:id/check' do
      account = current_user.available_accounts.first(:id => params[:id])
      return halt(400) if !account.healthy?
      status 200
    end

    get '/logs/:id' do
      @log = current_user.available_accounts.map { |a| a.logs.get(params[:id]) }.compact.first
      haml :log
    end

  end
end
