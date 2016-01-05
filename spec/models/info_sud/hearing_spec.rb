require 'rails_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Hearing do
  it_behaves_like InfoSud::Importable

  before :each do
    ActiveJob::Base.queue_adapter = :test
  end

  after :each do
    ActiveJob::Base.queue_adapter = :inline
  end

  describe 'after save' do
    let(:record) { build(:info_sud_hearing)  }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileHearingJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileHearingJob).with(record).on_queue('reconcilers')
      expect { record.update_attributes!({}) }.to have_enqueued_job(ReconcileHearingJob).with(record).on_queue('reconcilers')
    end
  end
end
