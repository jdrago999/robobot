ENV['APP_ENV'] ||= 'development'
require 'bundler'
Bundler.require(:default, ENV['APP_ENV'])

require 'active_support/all'
require 'byebug'
require 'pp'
require 'ostruct'

lib = File.expand_path('../../../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Dir['lib/**/*.rb'].each do |file|
  require file
end

require_relative 'application'

APP = Stubber::Application.new
