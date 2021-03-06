Gem::Specification.new do |spec|
  spec.name        = 'robobot'
  spec.version     = '0.1.0'
  spec.authors     = ['John Drago']
  spec.email       = 'drago@ambitrace.com'
  spec.homepage    = 'https://github.com/jdrago999/robobot'
  spec.summary     = 'Daemon for remote execution and testing'
  spec.description = 'Daemon for remote execution of tasks, eg: for testing software on a desktop OS'
  spec.required_rubygems_version = '>= 1.3.6'

  spec.files         = Dir['**/*'].keep_if { |file| File.file?(file) }
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'shoulda-matchers'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rubocop'

  spec.add_dependency 'redis'
  spec.add_dependency 'activesupport'
end
