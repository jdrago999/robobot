
# Stubber

## Usage

```ruby
Stubber::Server.configure do |config|
  config.node_id = ENV.fetch('NODE_ID')
  config.redis = Rails.application.redis
end
server = Stubber::Server.new(worker: Stubber::Worker::Windows.new)
server.listen!
```
