require 'sinatra'

post '/' do
  puts request.env["rack.input"].read
end
