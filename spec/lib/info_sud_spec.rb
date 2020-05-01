require 'rails_helper'
require 'info_sud'

RSpec.describe InfoSud do
  let(:downloader) { class_double(InfoSud::Downloader).as_stubbed_const }

  describe '.import_courts' do
    it 'imports courts from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::COURTS_URL) { 'path' }
      allow(InfoSud).to receive(:import).with('path', repository: InfoSud::Court)

      InfoSud.import_courts
    end
  end

  describe '.import_judges' do
    it 'imports judges from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::JUDGES_URL) { 'path' }
      allow(InfoSud).to receive(:import).with('path', repository: InfoSud::Judge)

      InfoSud.import_judges
    end
  end

  describe '.import_hearings' do
    it 'imports hearings from url' do
      allow(InfoSud::Downloader).to receive(:download_file).with(InfoSud::HEARINGS_URL) { 'path' }
      expect(InfoSud).to receive(:import).with('path', repository: InfoSud::Hearing)

      InfoSud.import_hearings
    end
  end


  describe '.import_decrees' do
    it 'imports decrees from url', vcr: { cassette_name: 'info_sud/decrees_import' } do
      urls = [
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2016_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2017_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2018_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-1_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-2_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-3_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-4_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-5_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-6_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-7_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-8_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-9_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-10_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-11_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2019-12_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2020-01_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2020-02_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2020-03_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2',
        'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_2020-04_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'
      ]

      urls.each.with_index do |url, i|
        allow(InfoSud::Downloader).to receive(:download_file).with(url) { "path-#{i}"}
        allow(InfoSud).to receive(:import).with("path-#{i}", repository: InfoSud::Decree)
      end

      InfoSud.import_decrees
    end
  end

  describe '.import' do
    let(:importer) { class_double(InfoSud::Importer).as_stubbed_const }
    let(:repository) { double(:repository) }

    it 'imports data from url to repository' do
      allow(Extractor).to receive(:extract).with('path').and_yield('Data 1').and_yield('Data 2')

      expect(importer).to receive(:import).with('Data 1', repository: repository)
      expect(importer).to receive(:import).with('Data 2', repository: repository)

      InfoSud.import('path', repository: repository)
    end
  end
end
