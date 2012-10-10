module DeltaControl

  module AppHelper

    def current_user
      #(session[:user_id] ||= 1) if self.class.development?
      return logout! unless logged_in?
      @_current_user ||= User.get(session['user_id'])
    end

    def current_user_reload
      @_current_user = nil
      current_user
    end

    def logged_in?
      puts session.inspect
      !session['user_id'].nil?
    end

    def logout!
      @_current_user = nil
      session['user_id'] = @_current_user
      redirect url('/login')
    end

  end

end
