ENV['APP_ENV'] ||= 'test'
require 'simplecov'
SimpleCov.start do
  add_filter 'spec/'
  add_filter 'bin/'
end
SimpleCov.minimum_coverage 100

lib = File.expand_path('../../', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'robobot-server'
require 'robobot-client'

require 'securerandom'
require 'rspec'
require 'shoulda-matchers'

ENV['REDIS_URL'] ||= 'redis://127.0.0.1:6379/0'

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
  end
end


RSpec.configure do |config|
  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = "random"
end
