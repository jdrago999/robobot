
module Robobot
  class Worker

    attr_accessor :node_id, :redis

    def initialize(node_id:, redis:)
      self.node_id = node_id
      self.redis = redis
    end

    def ping!(**args)
      :pong
    end
  end
end
