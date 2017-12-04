# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rails', '~> 5.1.4'
gem 'sass-rails'
gem 'sprockets'
gem 'sprockets-rails'
gem 'turbolinks'

# Internationalization
gem 'rails-i18n'

# Database
gem 'pg'

# Assets
gem 'bootstrap', '4.0.0.alpha2'
gem 'coffee-rails'
gem 'font-awesome-rails'
gem 'jquery-rails'
gem 'uglifier', '>= 1.3.0'

# Security
gem 'bcrypt'

# Serializers
gem 'active_model_serializers', '~> 0.10.0.rc3'
gem 'oj'
gem 'oj_mimic_json'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS)
# making cross-origin AJAX possible
# gem 'rack-cors'

# Async Processing
gem 'sidekiq'
gem 'sidekiq-limit_fetch'

# Configuration
gem 'dotenv-rails'
gem 'squire'

# Caching
gem 'dalli'

# Reporting
gem 'gabrake'
gem 'newrelic_rpm', '>= 3.15.0.314'
gem 'rollbar'

# Utilities
gem 'awesome_print'
gem 'curb'
gem 'mechanize'
gem 'nokogiri'
gem 'pdf-reader'
gem 'roo'
gem 'roo-xls'
gem 'rubyzip', require: 'zip'
gem 'symbolize'

# Codeclimate
gem 'codeclimate-test-reporter', group: :test, require: nil

# Scheduling
gem 'whenever'

group :development, :test do
  # Debugging
  gem 'capybara'
  gem 'database_rewinder'
  gem 'factory_girl_rails'
  gem 'fuubar'
  gem 'poltergeist'
  gem 'pry'
  gem 'pry-rails'
  gem 'rails-controller-testing'
  gem 'rspec-rails'
  gem 'ruby-prof'
  gem 'timecop'
  gem 'vcr'
end

group :test do
  gem 'webmock'
end

group :development do
  # Debugging
  # TODO wait for web-console to be ready for Rails 5
  gem 'web-console'

  # Deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-bundler'
  gem 'capistrano-git-submodule-strategy', '~> 0.1'
  gem 'capistrano-passenger'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-sidekiq'

  # Other
  gem 'bump', github: 'pavolzbell/bump'
  gem 'rubocop'
  gem 'spring'
end
