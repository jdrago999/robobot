
describe Stubber do
  describe '.configure(&block)' do
    context 'when called' do
      context 'with correct arguments' do
        before do
          @node_id = SecureRandom.hex(4)
          @redis = SecureRandom.hex(4)
          Stubber.configure do |config|
            config.redis = @redis
            config.node_id = @node_id
          end
        end
        it 'sets Stubb.redis' do
          expect(Stubber.redis).to eq(@redis)
        end
        it 'sets Stubb.node_id' do
          expect(Stubber.node_id).to eq(@node_id)
        end
      end
    end
  end
end
