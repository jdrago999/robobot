
# Robobot

![Robobot](doc/robobot.png)

## Usage

```ruby
require 'robobot-server'

class Win7 < Robobot::Worker
  def install_sensor!(hostname:, token:)
    command = './sensord install --org-hostname=%s --org-token=%s' % [hostname, token]
    system(command) or raise 'Error installing sensor!'
  end
end

worker = Win7.new(
  node_id: :win7,
  redis: Redis.new(url: ENV.fetch('REDIS_URL')),
)
server = Robobot::Server.new(worker: worker)
server.listen!
```

Then, somewhere else (in your test suite on another machine):

```ruby
require 'robobot-client'

client = Robobot::Client.new(
  redis: Redis.new(url: ENV.fetch('REDIS_URL')),
  node_id: 'win7',
)
begin
  result = client.install_sensor!(
    token: 'org.cb76e0b8-6ecb-11e8-9c81-ef849100e9c8',
    hostname: 't0000.ambitrace.local'
  )
rescue Robobot::RemoteError => e
  raise e
rescue StandardError => e
  raise e
end
```
