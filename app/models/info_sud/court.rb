module InfoSud
  class Court < ActiveRecord::Base
    extend InfoSud::Importable

    after_commit { ReconcileCourtJob.perform_later(self) }

    def to_mapper
      InfoSud::CourtMapper.new(self)
    end
  end
end
