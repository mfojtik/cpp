module Rack

  require 'json'
  require 'pry'

  class APILogger

    def initialize(app, no_cache_control = nil, cache_control = nil)
      @app = app
    end

    def call(env)
      req = Rack::Request.new(env)
      request_headers = env.select {|k,v| k.start_with? 'HTTP_' and !k.start_with? 'HTTP_AUTHORIZATION' }
      .reject { |k, v| k =~ /CCP/ }
      .collect {|pair| [pair[0].sub(/^HTTP_/, ''), pair[1]]}
      .collect {|pair| pair.join(": ") << "<br>"}
      .sort
      status, headers, body = @app.call(env)
      if req.path =~ /^\/api/ and !env['HTTP_X_CCP_ACCOUNT'].nil?
        DeltaControl::Log.create(
          :method => req.request_method,
          :uri => req.path,
          :driver => env['HTTP_X_DELTACLOUD_DRIVER'] || Thread.current[:driver],
          :status => status.to_i,
          :params => JSON.dump(req.params),
          :headers => request_headers.join,
          :user_id => env['HTTP_X_CCP_USER'],
          :account_id => env['HTTP_X_CCP_ACCOUNT'],
          :body => body.first
        )
      end
      [status, headers, body]
    end

  end
end

