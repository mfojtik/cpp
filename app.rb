require_relative './init.rb'

module DeltaControl
  class App < Sinatra::Base

    enable :session
    helpers ViewHelper
    helpers AppHelper

    # Enable flash[] messages through session
    before do
      @_flash, session[:_flash] = session[:_flash], nil if session[:_flash]
    end

    get '/' do
      haml :dashboard, :locals => { :title => 'Dashboard' }
    end

    get '/accounts' do
      @accounts = current_user.accounts
      haml :accounts
    end

    get '/accounts/new' do
      haml :new_account
    end

    post '/accounts' do
      account = Account.new(params[:account])
      current_user.accounts << account
      current_user.save
      flash[:notice] = 'Account "%s" successfully created.' % params[:account][:name]
      redirect url('/accounts')
    end

    get '/accounts/:id/delete' do
      account = current_user.accounts.first(:id => params[:id])
      flash[:notice] = 'Account "%s" successfully removed.' % account.name
      account.destroy!
      redirect url('/accounts')
    end

  end
end
