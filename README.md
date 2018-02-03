
# Stubber

## Usage

```ruby

class Win7 < Stubber::Worker
  def install_sensor!(version:, hostname:)
    command = 'TAObserveInstaller.%s.msi HOSTNAME=%s' % [version, hostname]
    system(command) or raise 'Error installing sensor!'
  end
end

Stubber::Server.configure do |config|
  config.node_id = ENV.fetch('NODE_ID')
  config.redis = Rails.application.redis
end
server = Stubber::Server.new(worker: Win7.new)
server.listen!
```
