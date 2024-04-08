# == Schema Information
#
# Table name: obcan_justice_sk_courts
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
  class Court < ActiveRecord::Base
    extend ObcanJusticeSk::Importable

    after_commit { ReconcileCourtJob.perform_later(self) }

    def to_mapper
      ObcanJusticeSk::CourtMapper.new(self.data)
    end
  end
end
