# frozen_string_literal: true

# Recorded responses of the sources (spec/fixtures/vcr), for specs tagged `vcr: { cassette_name: '...' }`.
VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.hook_into :webmock
  config.ignore_localhost = true
  config.configure_rspec_metadata!
end
