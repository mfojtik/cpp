module Rack

  require 'base64'

  class OverideDeltacloudAuth

    def initialize(app, no_cache_control = nil, cache_control = nil)
      @app = app
    end

    def call(env)
      if !env['HTTP_AUTHORIZATION'].nil?
        username, password = Base64.decode64(env['HTTP_AUTHORIZATION'].split(' ').last).split(':')
        user = DeltaControl::User.first(:name => username, :password => password)
        current_driver = env['HTTP_X_DELTACLOUD_DRIVER'] || Thread.current[:driver]
        accounts = user.accounts.all(:driver => current_driver)
        if !accounts.empty?
          if accounts.size > 0 and env['HTTP_X_DELTACLOUD_PROVIDER']
            account = accounts.first(:name => env['HTTP_X_DELTACLOUD_PROVIDER'])
          end
          account ||= accounts.first
          env['HTTP_AUTHORIZATION'] = "Basic "+Base64.encode64("#{account.username}:#{account.password}")
          env['HTTP_X_DELTACLOUD_PROVIDER'] = account.provider
          env['HTTP_X_CCP_ACCOUNT'] = account.id
          env['HTTP_X_CCP_USER'] = user.id
        end
      end
      @app.call(env)
    end

  end
end

