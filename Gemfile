source 'https://rubygems.org'

gem 'rack', '2.0.8'

gem 'rails', '~> 5.1.5'
gem 'sass-rails', '~> 5.0.7'
gem 'sprockets', '~> 3.7.2'
gem 'sprockets-rails', '~> 3.2.1'
gem 'turbolinks', '~> 5.1.0'

# Internationalization
gem 'rails-i18n', '~> 5.1.0'

# Database
gem 'pg', '~> 1.0.0'

# Assets
gem 'bootstrap', '4.0.0.alpha2'
gem 'coffee-rails', '~> 4.2.0'
gem 'font-awesome-rails', '~> 4.7.0.3'
gem 'jquery-rails', '~> 4.3.1'
gem 'uglifier', '>= 1.3.0'

# Security
gem 'bcrypt', '~> 3.1.11'

# Serializers
gem 'active_model_serializers', '~> 0.10.7'
gem 'oj', '~> 3.4.0'
gem 'oj_mimic_json', '~> 1.0.1'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
# making cross-origin AJAX possible
# gem 'rack-cors'

# Async Processing
gem 'sidekiq', '~> 5.2.10'
gem 'sidekiq-limit_fetch', '~> 3.4.0'

# Configuration
gem 'dotenv-rails', '~> 2.2.1'
gem 'squire', '~> 1.3.7'

# Caching
gem 'dalli', '~> 2.7.6'

# Reporting
gem 'newrelic_rpm', '~> 4.8.0.341'
gem 'rollbar'

# Utilities
gem 'awesome_print', '~> 1.8.0'
gem 'curb', '~> 0.9.11'
gem 'enumerize', '~> 2.2.1'
gem 'mechanize', '~> 2.7.5'
gem 'nokogiri', '~> 1.10.8'
gem 'pdf-reader', '~> 2.1.0'
gem 'roo', '~> 2.7.1'
gem 'roo-xls', '~> 1.1.0'

# Codeclimate
gem 'codeclimate-test-reporter', group: :test, require: nil

# Scheduling
gem 'whenever', '0.10.0'

group :development, :test do
  gem 'capybara', '~> 2.18.0'
  gem 'database_rewinder', '~> 0.8.3'
  gem 'factory_bot_rails', '~> 4.8.2'
  gem 'fuubar', '~> 2.3.1'
  gem 'poltergeist', '~> 1.17.0'
  gem 'pry'
  gem 'pry-rails'
  gem 'rails-controller-testing', '~> 1.0.2'
  gem 'rspec-rails', '~> 3.7.2'
  gem 'ruby-prof', '~> 0.17.0'
  gem 'spring', '~> 2.0.2'
  gem 'timecop', '~> 0.9.1'
  gem 'vcr', '~> 4.0.0'
end

group :test do
  gem 'webmock', '~> 3.3.0'
end

group :development do
  # Debugging
  gem 'web-console'

  # Deployment
  gem 'capistrano', '~> 3.10.1'
  gem 'capistrano-bundler'
  gem 'capistrano-git'
  gem 'capistrano-git-with-submodules'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-sidekiq'

  # Other
  gem 'bump', git: 'https://github.com/pavolzbell/bump.git'
  gem 'rubocop'
end
