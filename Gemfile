source 'https://rubygems.org'

# TODO once is Rails 5 released, replace with semiverions
gem 'rails', github: 'rails/rails'
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'sprockets', github: 'rails/sprockets'
gem 'sass-rails', github: 'rails/sass-rails'
gem 'arel', github: 'rails/arel'
gem 'rack', github: 'rack/rack'

# Internationalization
gem 'rails-i18n'

# Database
gem 'pg'

# Assets
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', github: 'rails/coffee-rails'
gem 'jquery-rails'
gem 'turbolinks'
gem 'bootstrap', github: 'twbs/bootstrap-rubygem'
gem 'font-awesome-rails', github: 'bokmann/font-awesome-rails'

# Security
gem 'bcrypt', '~> 3.1.7'

# Serializers
gem 'active_model_serializers', '~> 0.10.0.rc2'
gem 'oj'
gem 'oj_mimic_json'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Async Processing
gem 'sidekiq', '~> 4.0.1'
gem 'sidekiq-limit_fetch'
gem 'sinatra', github: 'sinatra/sinatra', branch: '2.2.0-alpha', require: nil # dependency of Sidekiq::Web

# Configuration
gem 'dotenv-rails'
gem 'squire'

# Reporting
gem 'rollbar', '~> 2.4.0'
gem 'gabrake', '~> 0.1.2'

# Utilities
gem 'symbolize'
gem 'curb'
gem 'nokogiri'
gem 'mechanize'
gem 'rubyzip', require: 'zip'
gem 'awesome_print'
gem 'pdf-reader'

# Codeclimate
gem 'codeclimate-test-reporter', group: :test, require: nil

# Scheduling
gem 'whenever'

group :development, :test do
  # Debugging
  gem 'pry'
  gem 'pry-rails'
  gem 'ruby-prof'

  # Testing
  # TODO once rspec for Rails 5 is released, remove
  %w[rspec-rails rspec rspec-core rspec-expectations rspec-mocks rspec-support].each do |lib|
    gem lib, github: "rspec/#{lib}"
  end

  gem 'fuubar'
  gem 'database_rewinder'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'rails-controller-testing'
  gem 'capybara'
  gem 'poltergeist'
  gem 'vcr'
  gem 'timecop'
end

group :test do
  gem 'webmock'
end

group :development do
  # Debugging
  # TODO wait for web-console to be ready for Rails 5
  # gem 'web-console', github: 'rails/web-console'

  # Deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rbenv', '~> 2.0'
  gem 'capistrano-passenger'
  gem 'capistrano-sidekiq'

  # Other
  gem 'bump', github: 'pavolzbell/bump'
  gem 'spring'
end
