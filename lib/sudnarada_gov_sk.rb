require 'unicode_string'
require 'legacy/normalizer'

module SudnaradaGovSk
  require 'sudnarada_gov_sk/declarations_parser'
  require 'sudnarada_gov_sk/declarations_importer'

  def self.import_declarations(path)
    DeclarationsImporter.import(path)
  end
end
