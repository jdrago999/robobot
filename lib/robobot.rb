
require 'redis'
require 'logger'

module Robobot
  class RemoteError < StandardError; end

  def self.logger
    @@logger ||= Logger.new(STDERR)
  end
end
