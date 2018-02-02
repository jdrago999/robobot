#!/usr/bin/env ruby

lib = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'config/environment'

require 'dotenv'
Dotenv.load

Stubber.configure do |config|
  config.node_id = ENV.fetch('NODE_ID')
  config.redis = Redis.new(url: ENV.fetch('REDIS_URL'))
end
server = Stubber::Server.new
server.listen!
