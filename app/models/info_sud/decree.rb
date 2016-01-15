module InfoSud
  class Decree < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit { ReconcileDecreeJob.perform_later(self) }

    def to_mapper
      InfoSud::DecreeMapper.new(self.data)
    end
  end
end
