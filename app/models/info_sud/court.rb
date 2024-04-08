# == Schema Information
#
# Table name: info_sud_courts
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module InfoSud
  class Court < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit { ReconcileCourtJob.perform_later(self) }

    def to_mapper
      InfoSud::CourtMapper.new(self.data)
    end
  end
end
