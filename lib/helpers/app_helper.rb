module DeltaControl

  module AppHelper

    def current_user
      (session[:user_id] ||= 1) if self.class.development?
      return logout! unless logged_in?
      @_current_user ||= User.get(session[:user_id]).to_struct
    end

    def current_user_reload
      @_current_user = nil
      current_user
    end

    def logged_in?
      !session[:user_id].nil?
    end

    def logout!
      session[:user_id] = nil
      @_current_user = nil
      redirect url('/')
    end

  end

end
