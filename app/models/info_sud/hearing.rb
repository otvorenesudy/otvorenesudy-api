module InfoSud
  class Hearing < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit { ReconcileHearingJob.perform_later(self) }

    def to_mapper
      InfoSud::HearingMapper.new(self.data)
    end
  end
end
