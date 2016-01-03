module InfoSud
  class Judge < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit { ReconcileJudgeJob.perform_later(self) }

    def to_mapper
      InfoSud::JudgeMapper.new(self.data)
    end
  end
end
