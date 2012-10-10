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
      haml :accounts
    end

  end
end
