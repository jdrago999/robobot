
module Stubber
  class Application
    def redis
      @redis ||= Redis.new(url: 'redis://%s:6379/0' % ENV['REDIS_HOSTNAME'])
    end
  end
end
