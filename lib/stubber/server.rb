
module Stubber
  class Server

    attr_accessor :worker

    def initialize(worker:nil)
      self.worker = worker
    end

    def listen!
      logger.info 'Waiting for message for %s' % task_key
      loop do
        list, task_raw = worker.redis.blpop(task_key)
        next unless list == task_key && task_raw
        task = JSON.parse(task_raw, symbolize_names: true)
        return_path = task.fetch(:return_path)
        action = task[:action]
        args = task.fetch(:args)
        case action
        when 'stop'
          stop!(return_path: return_path)
          break
        else
          begin
            result = worker.public_send(action, args)
            result_json = {
              status: :success,
              result: result
            }.to_json
            logger.info '%s->%s(%s) = %s' % [worker.class, action, args, result]
            worker.redis.rpush(return_path, result_json)
          rescue => e
            result_json = {
              status: :error,
              result: {
                type: e.class.to_s,
                message: e.to_s
              }
            }.to_json
            worker.redis.rpush(return_path, result_json)
            logger.error 'Unhandled task: "%s"' % task_raw
          end
        end
      end
    end

    def task_key
      'task:%s' % worker.node_id
    end

    private

    def stop!(return_path:)
      result_json = {
        status: :success,
        result: :ok
      }.to_json
      worker.redis.rpush(return_path, result_json)
    end

    def logger
      Stubber.logger
    end

  end
end
