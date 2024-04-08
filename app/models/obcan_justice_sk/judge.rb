# == Schema Information
#
# Table name: obcan_justice_sk_judges
#
#  id         :bigint           not null, primary key
#  guid       :string           not null
#  uri        :string           not null
#  data       :jsonb            not null
#  checksum   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module ObcanJusticeSk
  class Judge < ActiveRecord::Base
    extend ObcanJusticeSk::Importable
  end
end
