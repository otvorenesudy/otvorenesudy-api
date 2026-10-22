# frozen_string_literal: true

require 'zip'

# The sources' APIs answer JSON; specs fake them with WebMock at their real addresses.
module SourceHelpers
  def stub_json(url, body, status: 200)
    stub_request(:get, url).to_return(status:, body: body.to_json, headers: { 'Content-Type' => 'application/json' })
  end

  def source_fixture(name)
    JSON.parse(file_fixture("obcan_justice_sk/mappers/#{name}.json").read)
  end

  # An InfoSud dump: a zip archive of JSON files ({"data": [records]}), downloaded as the file the source names.
  def stub_info_sud_dump(url, filename, *contents)
    archive = Zip::OutputStream.write_buffer do |zip|
      contents.each_with_index do |content, index|
        zip.put_next_entry("#{index}.json")
        zip.write(content)
      end
    end

    stub_request(:get, url).to_return(
      body: archive.string,
      headers: { 'Content-Type' => 'application/zip', 'Content-Disposition' => %(attachment; filename="#{filename}") }
    )
  end
end

RSpec.configure do |config|
  config.include SourceHelpers
end
