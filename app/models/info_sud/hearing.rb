# == Schema Information
#
# Table name: info_sud_hearings
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module InfoSud
  class Hearing < ApplicationRecord
    extend InfoSud::Importable

    after_commit(on: %i[create update]) { ReconcileHearingJob.perform_later(self) }

    def to_mapper
      InfoSud::HearingMapper.new(self.data)
    end
  end
end
