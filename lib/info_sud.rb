require 'oj'

module InfoSud
  require 'info_sud/parser'
  require 'info_sud/importer'

  def self.import_courts
    Dir[Rails.root.join('tmp/data/info_sud/courts/*.json')].each do |file|
      InfoSud::Importer.import(file, repository: InfoSud::Court)
    end
  end

  def self.import_judges
    Dir[Rails.root.join('tmp/data/info_sud/judges/*.json')].each do |file|
      InfoSud::Importer.import(file, repository: InfoSud::Judge)
    end
  end

  def self.import_hearings
    Dir[Rails.root.join('tmp/data/info_sud/hearings/*.json')].each do |file|
      InfoSud::Importer.import(file, repository: InfoSud::Hearing)
    end
  end

  def self.table_name_prefix
    'info_sud_'
  end
end
