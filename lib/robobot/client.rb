
module Robobot
  class Client
    attr_accessor :redis, :node_id, :task_key

    def initialize(redis:, node_id:)
      self.redis = redis
      self.node_id = node_id
      self.task_key = 'task:%s' % node_id
    end

    # Only catch methods that end in ! or ?
    def method_missing(name, args={})
      raise NoMethodError unless name =~ %r{[\!\?]$}
      timeout = args.delete(:timeput) || 30
      remote_exec(action: name, args: args, timeout: timeout)
    end

    def remote_exec(action:, args:{}, timeout: 30)
      return_path = '%s:return-path:%s' % [task_key, SecureRandom.uuid]
      task = {
        action: action,
        args: args,
        return_path: return_path
      }.to_json
      redis.rpush(task_key, task)

      # Wait for response:
      list, raw_result = redis.blpop(return_path, timeout: timeout)
      response = JSON.parse(raw_result, symbolize_names: true)
      case response[:status]
      when 'success'
        response.fetch(:result)
      else
        type = response[:result].fetch(:type)
        message = response[:result].fetch(:message)
        raise Robobot::RemoteError.new "ERROR --- #{type}: #{message}"
      end
    end
  end
end
