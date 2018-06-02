
describe Robobot::Server do
  before do
    @redis = Redis.new(url: ENV.fetch('REDIS_URL'))
    @redis.keys('return-path:*').map{|x| @redis.del(x) }
    @redis.keys('task:*').map{|x| @redis.del(x) }
    @worker_klass = Class.new(Robobot::Worker)
  end

  describe '.initialize' do
    before do
      @worker = @worker_klass.new(
        node_id: :win7,
        redis: @redis
      )
      @server = described_class.new(worker: @worker)
    end
    it 'creates a new server object with the correct configuration' do
      expect(@server.node_id).to eq(@worker.node_id)
      expect(@server.redis).to eq(@worker.redis)
      expect(@server.task_key).to eq('task:%s' % @worker.node_id)
    end
  end

  describe '#listen!' do
    before do
      @return_path = 'return-path:%s' % SecureRandom.hex(4)
    end
    context 'when the action is' do
      context ':stop' do
        before do
          @worker = @worker_klass.new(
            node_id: :win7,
            redis: @redis
          )
          @server = described_class.new(worker: @worker)
          task = {
            action: :stop,
            args: {},
            return_path: @return_path
          }.to_json
          @redis.rpush(@server.task_key, task)
          expect(@server.redis).to receive(:rpush).with(@return_path, {status: :success, result: :ok}.to_json)
        end
        it 'stops and returns the result to the correct return path' do
          @server.listen!
        end
      end
      context 'handled by a worker' do
        before do
          @worker = @worker_klass.new(
            node_id: :win7,
            redis: @redis
          )
          @server = described_class.new(worker: @worker)
          task = {
            action: :ping!,
            args: {name: @name},
            return_path: @return_path
          }.to_json
          @redis.rpush(@server.task_key, task)
          task = {
            action: :stop,
            args: {},
            return_path: @return_path
          }.to_json
          @redis.rpush(@server.task_key, task)
        end
        it 'stops and returns the result to the correct return path' do
          @server.listen!
          _, return_value = @redis.blpop(@return_path)
          result = JSON.parse(return_value)
          expect(result.fetch('status')).to eq('success')
          expect(result.fetch('result')).to eq('pong')
        end
      end
      context 'not handled by a worker' do
        before do
          @worker = @worker_klass.new(
            node_id: :win7,
            redis: @redis
          )
          @server = described_class.new(worker: @worker)
          @name = SecureRandom.hex(6)
          task = {
            action: :invalid_action,
            args: {},
            return_path: @return_path
          }.to_json
          @redis.rpush(@server.task_key, task)
          task = {
            action: :stop,
            args: {},
            return_path: @return_path
          }.to_json
          @redis.rpush(@server.task_key, task)
          @server.listen!
          _, return_value = @redis.blpop(@return_path)
          @result = JSON.parse(return_value)
        end
        it 'returns an :error result' do
          expect(@result.fetch('status')).to eq('error')
          expect(@result.fetch('result').fetch('type')).to eq('NoMethodError')
        end
      end
    end
  end
end
