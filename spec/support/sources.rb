# frozen_string_literal: true

# The sources' APIs answer JSON; specs fake them with WebMock at their real addresses.
module SourceHelpers
  def stub_json(url, body, status: 200)
    stub_request(:get, url).to_return(status:, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def source_fixture(name)
    JSON.parse(file_fixture("obcan_justice_sk/mappers/#{name}.json").read)
  end
end

RSpec.configure do |config|
  config.include SourceHelpers
end
