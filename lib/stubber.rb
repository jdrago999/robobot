
module Stubber
  @@redis = nil
  @@node_id = nil
  @@logger = Logger.new(STDERR)

  def self.configure(&block)
    config = OpenStruct.new(redis: nil, node_id: nil, logger: nil)
    block.call(config)
    @@redis = config.redis
    @@node_id = config.node_id
    @@logger = logger if logger
  end

  def self.redis
    @@redis
  end

  def self.node_id
    @@node_id
  end

  def self.logger
    @@logger
  end
end
