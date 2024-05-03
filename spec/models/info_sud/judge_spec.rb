# == Schema Information
#
# Table name: info_sud_judges
#
#  id         :integer          not null, primary key
#  guid       :string           not null
#  data       :jsonb            not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'spec_helper'
require 'models/concerns/info_sud/importable_spec'

RSpec.describe InfoSud::Judge, active_job: { adapter: :test } do
  it_behaves_like InfoSud::Importable

  describe 'after save' do
    let(:record) { build(:info_sud_judge) }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileJudgeJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileJudgeJob).with(record).on_queue('reconcilers')
      expect { record.update!({}) }.to have_enqueued_job(ReconcileJudgeJob).with(record).on_queue('reconcilers')
    end
  end
end
