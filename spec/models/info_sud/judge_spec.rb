require 'spec_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Judge do
  it_behaves_like InfoSud::Importable

  before :each do
    ActiveJob::Base.queue_adapter = :test
  end

  after :each do
    ActiveJob::Base.queue_adapter = :inline
  end

  describe 'after save' do
    let(:record) { build(:info_sud_judge)  }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileJudgeJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileJudgeJob).with(record).on_queue('reconcilers')
      expect { record.update_attributes!({}) }.to have_enqueued_job(ReconcileJudgeJob).with(record).on_queue('reconcilers')
    end
  end
end
