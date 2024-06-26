# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'capybara/rails'
# Add additional requires below this line. Rails is not loaded until this point!

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

Capybara.javascript_driver = :selenium_chrome_headless

RSpec.configure do |config|
  config.include RSpec::Rails::Matchers

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true
  config.use_transactional_fixtures = false

  # DatabaseCleaner
  config.before(:suite) do
    DatabaseCleaner[:active_record].strategy = :deletion
    DatabaseCleaner[:active_record, db: OpenCourts::ApplicationRecord].strategy = :deletion
  end

  config.before(:each) { DatabaseCleaner.start }
  config.after(:each) { DatabaseCleaner.clean }

  # ActiveJob
  config.around(:each, :active_job) do |example|
    former_adapter = ActiveJob::Base.queue_adapter
    ActiveJob::Base.queue_adapter = example.metadata[:active_job][:adapter]

    example.run

    ActiveJob::Base.queue_adapter = former_adapter
  end

  # Factory syntax suggar
  config.include FactoryBot::Syntax::Methods

  # Controller helpers that are part of rails-controller-testing gem
  config.include Rails::Controller::Testing::TestProcess
  config.include Rails::Controller::Testing::TemplateAssertions
  config.include Rails::Controller::Testing::Integration

  # ActiveJob helper methods
  config.include ActiveJobHelper

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!
end
