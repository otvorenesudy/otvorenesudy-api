require 'curl'
require 'json-schema'
require 'json'
require 'active_support/all'
require 'legacy'

module ObcanJusticeSk
  require 'obcan_justice_sk/normalizer'
  require 'obcan_justice_sk/courts'
  require 'obcan_justice_sk/judges'
  require 'obcan_justice_sk/civil_hearings'
  require 'obcan_justice_sk/criminal_hearings'

  def self.table_name_prefix
    'obcan_justice_sk_'
  end
end
