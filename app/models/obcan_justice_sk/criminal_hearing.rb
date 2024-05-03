# == Schema Information
#
# Table name: obcan_justice_sk_criminal_hearings
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
  class CriminalHearing < ActiveRecord::Base
    extend ObcanJusticeSk::Importable

    before_save :anonymize_defendants

    after_commit(on: %i[create update]) { ReconcileHearingJob.perform_later(self) }

    def to_mapper
      ObcanJusticeSk::CriminalHearingMapper.new(self)
    end

    def anonymize_defendants
      return if data.blank? || data['obzalovani'].blank?

      data['obzalovani'] = data['obzalovani'].map { HearingReconciler::RandomInitialsProvider.provide }
    end
  end
end
