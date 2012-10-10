module Rack

  require 'json'
  require 'pry'

  class APILogger

    def initialize(app, no_cache_control = nil, cache_control = nil)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      status, headers, body = @app.call(env)
      if req.path =~ /^\/api\// and !env['HTTP_X_CCP_ACCOUNT'].nil?
        DeltaControl::Log.create(
          :method => req.request_method,
          :uri => req.path,
          :driver => env['HTTP_X_DELTACLOUD_DRIVER'] || Thread.current[:driver],
          :status => status,
          :params => JSON.dump(req.params),
          :user_id => env['HTTP_X_CCP_USER'],
          :account_id => env['HTTP_X_CCP_ACCOUNT']
        )
      end
      [status, headers, body]
    end

  end
end

