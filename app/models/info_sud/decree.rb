# == Schema Information
#
# Table name: info_sud_decrees
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
module InfoSud
  class Decree < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit(on: %i[create update]) { ReconcileDecreeJob.perform_later(self) }

    def to_mapper
      InfoSud::DecreeMapper.new(self.data)
    end
  end
end
