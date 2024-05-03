# == Schema Information
#
# Table name: obcan_justice_sk_civil_hearings
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
  class CivilHearing < ActiveRecord::Base
    extend ObcanJusticeSk::Importable

    after_commit(on: %i[create update]) { ReconcileHearingJob.perform_later(self) }

    def to_mapper
      ObcanJusticeSk::CivilHearingMapper.new(self)
    end
  end
end
