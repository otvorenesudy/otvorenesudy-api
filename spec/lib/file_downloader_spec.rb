require 'spec_helper'
require 'file_downloader'

RSpec.describe FileDownloader do
  describe '.download' do
    let(:url) { 'https://obcan.justice.sk/content/public/item/d377e7ef-a20a-4f93-a031-87994c4d5ad0' }

    it 'downloads file and yields the path', vcr: { cassette_name: 'example.pdf' } do
      path = '/tmp/file-downloader-tmp-file-0ee5cb2652ba9d08f28c952ee7b3778aeb70f78a029da3166a6e1007c6c01503'

      expect { |block| FileDownloader.download(url, directory: '/tmp', &block) }.to yield_with_args(path)

      expect(File.exist?(path)).to eql(false)
    end
  end
end
