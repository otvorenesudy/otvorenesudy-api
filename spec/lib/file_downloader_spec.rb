require 'spec_helper'
require 'file_downloader'

RSpec.describe FileDownloader do
  describe '.download' do
    let(:url) { 'https://obcan.justice.sk/content/public/item/d377e7ef-a20a-4f93-a031-87994c4d5ad0' }

    it 'downloads file and saves it with name as a hash', vcr: { cassette_name: 'example.pdf' } do
      path = FileDownloader.download(url, directory: '/tmp')

      expect(path).to eql('/tmp/0ee5cb2652ba9d08f28c952ee7b3778aeb70f78a029da3166a6e1007c6c01503')
    end
  end
end
