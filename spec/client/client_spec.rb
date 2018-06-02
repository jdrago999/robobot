
describe Robobot::Client do
  describe '.initialize(redis:, node_id:)' do
    before do
      @redis = :redis
      @node_id = SecureRandom.uuid
      @client = described_class.new(redis: @redis, node_id: @node_id)
    end
    it 'initializes itself properly' do
      expect(@client.redis).to eq(@redis)
      expect(@client.node_id).to eq(@node_id)
      expected_task_key = 'task:%s' % @node_id
      expect(@client.task_key).to eq(expected_task_key)
    end
  end

  describe '#method_missing(name, args)' do
    before do
      @redis = :redis
      @node_id = SecureRandom.uuid
      @client = described_class.new(redis: @redis, node_id: @node_id)
    end
    context 'when the missing method' do
      context 'ends with !' do
        before do
          @method = 'foo%s!' % SecureRandom.hex(4)
        end
        it 'calls remote_exec' do
          expect(@client).to receive(:remote_exec).with(action: @method.to_sym, args:{}, timeout: 30)
          @client.send(@method)
        end
      end
      context 'ends with ?' do
        before do
          @method = 'foo%s?' % SecureRandom.hex(4)
        end
        it 'calls remote_exec' do
          expect(@client).to receive(:remote_exec).with(action: @method.to_sym, args:{}, timeout: 30)
          @client.send(@method)
        end
      end
      context 'does not end with ! or ?' do
        before do
          @method = 'foo%s' % SecureRandom.hex(4)
        end
        it 'raises an exception' do
          expect{@client.send(@method)}.to raise_error NoMethodError
        end
      end
    end
  end

  describe '#remote_exec(action:, args:{}, timeout:30)' do
    before do
      @redis = double('redis')
      @node_id = SecureRandom.uuid
      @client = described_class.new(redis: @redis, node_id: @node_id)
    end
    context 'when execution' do
      context 'succeeds' do
        before do
          @return_path = nil
          expect(@redis).to receive(:rpush) do |list, args|
            data = JSON.parse(args)
            @return_path = data['return_path']
          end
          @data = SecureRandom.uuid
          response = {
            status: :success,
            result: {data: @data}
          }
          expect(@redis).to receive(:blpop).and_return([@return_path, response.to_json])
        end
        it 'returns the response' do
          response = @client.remote_exec(action: :foo, args: {})
          expect(response[:data]).to eq(@data)
        end
      end
      context 'fails' do
        before do
          @return_path = nil
          expect(@redis).to receive(:rpush) do |list, args|
            data = JSON.parse(args)
            @return_path = data['return_path']
          end
          @data = SecureRandom.uuid
          response = {
            status: :error,
            result: {
              type: 'TestError',
              message: 'test error message'
            }
          }
          expect(@redis).to receive(:blpop).and_return([@return_path, response.to_json])
        end
        it 'raises an informative exception' do
          expect{@client.remote_exec(action: :foo, args: {})}.to raise_error Robobot::RemoteError
        end
      end
    end
  end
end
