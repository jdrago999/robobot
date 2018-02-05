
# Stubber

## Usage

```ruby
class Win7 < Stubber::Worker
  def install_sensor!(version:, hostname:)
    command = 'TAObserveInstaller.%s.msi HOSTNAME=%s' % [version, hostname]
    system(command) or raise 'Error installing sensor!'
  end
end

worker = Win7.new(
  node_id: :win7,
  redis: Redis.new(url: ENV.fetch('REDIS_URL')),
)
server = Stubber::Server.new(worker: worker)
server.listen!
```

Then, somewhere else (in your test suite on another machine):

```ruby
require 'stubber-client'

client = Stubber::Client.new(
  redis: Redis.new(url: ENV.fetch('REDIS_URL')),
  node_id: 'win7',
)
begin
  result = client.install_sensor!(
    version: '1.0.2.101',
    hostname: 'tenant0.thinair.local'
  )
rescue Stubber::RemoteError => e
  raise e
rescue StandardError => e
  raise e
end
```
