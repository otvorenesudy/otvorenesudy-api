require 'oj'
require 'mechanize'
require 'legacy'
require 'active_support/all'
require 'extractor'

module InfoSud
  require 'info_sud/parser'
  require 'info_sud/importer'
  require 'info_sud/downloader'
  require 'info_sud/normalizer'

  COURTS_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=reg-sudy_json&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'
  JUDGES_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=reg-sudcovia_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'
  HEARINGS_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sp_json.zip&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'

  def self.import_courts
    path = InfoSud::Downloader.download_file(COURTS_URL)

    import(path, repository: InfoSud::Court)
  end

  def self.import_judges
    path = InfoSud::Downloader.download_file(JUDGES_URL)

    import(path, repository: InfoSud::Judge)
  end

  def self.import_hearings
    path = InfoSud::Downloader.download_file(HEARINGS_URL)

    import(path, repository: InfoSud::Hearing)
  end

  def self.import_decrees
    urls = Nokogiri::HTML(Curl.get('https://obcan.justice.sk/opendata').body_str).css('a').map { |e|
      e['href']
    }.select { |e| e.match(/p_p_resource_id=isu_sr.+_json.zip/) }

    urls.each do |url|
      path = InfoSud::Downloader.download_file(url)

      import(path, repository: InfoSud::Decree)
    end
  end

  def self.import(path, repository:)
    Extractor.extract(path) do |data|
      InfoSud::Importer.import(data, repository: repository)
    end
  end

  def self.table_name_prefix
    'info_sud_'
  end
end
