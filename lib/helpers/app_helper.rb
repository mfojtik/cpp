module DeltaControl

  module AppHelper

    def current_user
      return logout! unless logged_in?
      @_current_user ||= User.get(session['user_id'])
    end

    def current_user_reload
      @_current_user = nil
      current_user
    end

    def logged_in?
      !session['user_id'].nil?
    end

    def logout!
      @_current_user = nil
      session['user_id'] = @_current_user
      redirect url('/login')
    end

    def redirect(uri, *args)
      session[:_flash] = flash unless flash.empty?
      status 302
      response['Location'] = uri
      halt(*args)
    end

  end

end
