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
  class Judge < ApplicationRecord
    extend ObcanJusticeSk::Importable

    after_commit(on: %i[create update]) { ReconcileJudgeJob.perform_later(self) }

    def to_mapper
      ObcanJusticeSk::JudgeMapper.new(self)
    end

    def courts_as_judicial_council_chairman
      ObcanJusticeSk::Court.where(
        "data @@ '$.srPredseda.sudcovia[*].id == #{sanitized_short_guid_for_json_path_queries}'"
      )
    end

    def courts_as_judicial_council_member
      ObcanJusticeSk::Court.where("data @@ '$.srClen.sudcovia[*].id == #{sanitized_short_guid_for_json_path_queries}'")
    end

    private

    def sanitized_short_guid_for_json_path_queries
      short_guid = data['registreGuid'].gsub(/\Asudca_/, '')
      sanitized_short_guid = ApplicationRecord.connection.quote_string(short_guid)

      Arel.sql(%Q["#{sanitized_short_guid}"])
    end
  end
end
