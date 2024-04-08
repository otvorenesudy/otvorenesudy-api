# == Schema Information
#
# Table name: info_sud_courts
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Court, active_job: { adapter: :test } do
  it_behaves_like InfoSud::Importable

  describe 'after save' do
    let(:record) { build(:info_sud_court) }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileCourtJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileCourtJob).with(record).on_queue('reconcilers')
      expect { record.update!({}) }.to have_enqueued_job(ReconcileCourtJob).with(record).on_queue('reconcilers')
    end
  end
end
