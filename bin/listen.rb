#!/usr/bin/env ruby

lib = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'config/environment'

Stubber.configure do |config|
  config.node_id = ENV.fetch('NODE_ID')
  config.redis = Redis.new(url: 'redis://%s:6379/0' % ENV['REDIS_HOSTNAME'])
end
server = Stubber::Server.new
server.listen!
