source 'https://rubygems.org'

# TODO once is Rails 5 released, replace with semiverions
gem 'rails', github: 'rails/rails'
gem 'sprockets-rails', github: 'rails/sprockets-rails'
gem 'sprockets', github: 'rails/sprockets'
gem 'sass-rails', github: 'rails/sass-rails'
gem 'arel', github: "rails/arel"
gem 'rack', github: "rack/rack"

# Database
gem 'pg'

# Security
gem 'bcrypt', '~> 3.1.7'

# Server
gem 'unicorn'

# Serializers
gem 'active_model_serializers', '~> 0.10.0.rc2'

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Debugging
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry'

  # Testing
  gem 'rspec-rails', '~> 3.0'
  gem 'fuubar'
  gem 'database_cleaner'
  gem 'factory_girl_rails', '~> 4.5'

  # Configuration
  gem 'dotenv-rails'
  gem 'squire'
end

group :development do
  # Deployment
  gem 'capistrano', '~> 3.1'
  gem 'capistrano-rails', '~> 1.1'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
# gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
