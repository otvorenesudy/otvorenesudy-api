source 'https://rubygems.org'

# TODO once is Rails 5 released, replace with semiverions
gem 'rails', github: 'rails/rails'
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'sprockets', github: 'rails/sprockets'
gem 'sass-rails', github: 'rails/sass-rails'
gem 'arel', github: 'rails/arel'
gem 'rack', github: 'rack/rack'

# Database
gem 'pg'

# Security
gem 'bcrypt', '~> 3.1.7'

# Server
gem 'unicorn'

# Serializers
gem 'active_model_serializers', '~> 0.10.0.rc2'
gem 'oj'
gem 'oj_mimic_json'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

# Configuration
gem 'dotenv-rails'
gem 'squire'

# Error reporting
gem 'rollbar', '~> 2.4.0'

group :development, :test do
  # Debugging
  gem 'byebug'
  gem 'pry'

  # Testing
  gem 'rspec-rails', '~> 3.0'
  gem 'fuubar'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.5'
  gem 'rails-controller-testing'
end

group :development do
  # Deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'
  gem 'capistrano-bundler'
  gem 'capistrano-rvm'
  gem 'capistrano3-unicorn'

  # Other
  gem 'bump', github: 'pavolzbell/bump'
  gem 'spring'
end
