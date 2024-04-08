# == Schema Information
#
# Table name: info_sud_judges
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module InfoSud
  class Judge < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit { ReconcileJudgeJob.perform_later(self) }

    def to_mapper
      InfoSud::JudgeMapper.new(self.data)
    end
  end
end
