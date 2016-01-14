require 'rails_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Decree, active_job: { adapter: :test } do
  it_behaves_like InfoSud::Importable

  describe 'after save' do
    let(:record) { build(:info_sud_decree)  }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileDecreeJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileDecreeJob).with(record).on_queue('reconcilers')
      expect { record.update_attributes!({}) }.to have_enqueued_job(ReconcileDecreeJob).with(record).on_queue('reconcilers')
    end
  end
end
