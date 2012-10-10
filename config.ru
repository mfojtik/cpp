require 'bundler'

Bundler.setup :default
Bundler.require

Deltacloud::configure do |server|
  server.root_url '/api'
  server.version Deltacloud::API_VERSION
  server.klass 'Deltacloud::API'
end
Deltacloud[:deltacloud].require!

$:.unshift File.dirname(__FILE__)
require './app'

run Rack::Builder.new {
  use Rack::MatrixParams
  run Rack::URLMap.new(
    '/' => DeltaControl::App,
    '/api' => Deltacloud[:deltacloud].klass
  )
}