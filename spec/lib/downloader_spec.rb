# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Downloader do
  describe '.get' do
    let(:url) { 'https://www.genpro.gov.sk/prokuratura-sr/menny-zoznam-prokuratorov-slovenskej-republiky-3928.html' }

    it 'tries again when a download fails' do
      stub_request(:get, url).to_timeout.then.to_return(body: 'Prokuratori')
      response = nil

      expect { response = described_class.get(url, wait: 0) }
        .to output("Retrying download (Curl::Err::TimeoutError) ... #1\n").to_stderr
      expect(response.body_str).to eq('Prokuratori')
    end

    it 'gives up after ten tries' do
      stub_request(:get, url).to_timeout

      expect { described_class.get(url, wait: 0) }
        .to raise_error(StandardError, "Failed to download #{url}")
        .and output(/\A(Retrying download \(Curl::Err::TimeoutError\) \.\.\. #\d+\n){10}\z/).to_stderr
    end
  end
end
