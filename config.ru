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
require './lib/rack/rack_overide_deltacloud_auth'

run Rack::Builder.new {
  use Rack::MatrixParams
  use Rack::OverideDeltacloudAuth
  run Rack::URLMap.new(
    '/' => DeltaControl::App,
    '/api' => Deltacloud[:deltacloud].klass
  )
}
