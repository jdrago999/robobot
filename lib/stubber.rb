
module Stubber

  def self.logger
    @@logger ||= Logger.new(STDERR)
  end
end
