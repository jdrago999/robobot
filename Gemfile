source 'https://rubygems.org'

# Use Puma as the app server
gem 'redis'
gem 'redis-namespace'
gem 'dotenv'
gem 'activesupport'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'spring'
end

group :test do
  gem 'rspec'
  gem 'shoulda-matchers'
  gem 'factory_bot'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
