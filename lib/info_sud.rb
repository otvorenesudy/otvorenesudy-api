require 'oj'
require 'mechanize'
require 'zip'
require 'legacy'

module InfoSud
  require 'info_sud/parser'
  require 'info_sud/importer'
  require 'info_sud/downloader'
  require 'info_sud/extractor'
  require 'info_sud/normalizer'
  require 'info_sud/court_mapper'
  require 'info_sud/judge_mapper'

  COURTS_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=reg-sudy_json&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'
  JUDGES_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=reg-sudcovia_json&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'
  HEARINGS_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sp_json&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'
  DECREES_URL = 'https://obcan.justice.sk/opendata?p_p_id=isuopendata_WAR_isufront&p_p_lifecycle=2&p_p_state=normal&p_p_mode=view&p_p_resource_id=isu_sr_json&p_p_cacheability=cacheLevelPage&p_p_col_id=column-2&p_p_col_pos=1&p_p_col_count=2'

  def self.import_courts
    import(COURTS_URL, repository: InfoSud::Court)
  end

  def self.import_judges
    import(JUDGES_URL, repository: InfoSud::Judge)
  end

  def self.import_hearings
    import(HEARINGS_URL, repository: InfoSud::Hearing)
  end

  def self.import_decrees
    import(DECREES_URL, repository: InfoSud::Decree)
  end

  def self.import(url, repository:)
    path = InfoSud::Downloader.download_file(url)

    InfoSud::Extractor.extract(path) do |data|
      InfoSud::Importer.import(data, repository: repository)
    end
  end

  def self.table_name_prefix
    'info_sud_'
  end
end
