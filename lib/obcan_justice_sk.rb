require 'curl'
require 'json-schema'
require 'json'
require 'active_support/all'
require 'legacy'

module ObcanJusticeSk
  require 'obcan_justice_sk/normalizer'
  require 'obcan_justice_sk/courts'

  def self.table_name_prefix
    'obcan_justice_sk_'
  end
end
