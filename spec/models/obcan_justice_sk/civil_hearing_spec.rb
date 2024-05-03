# == Schema Information
#
# Table name: obcan_justice_sk_civil_hearings
#
#  id         :bigint           not null, primary key
#  guid       :string           not null
#  uri        :string           not null
#  data       :jsonb            not null
#  checksum   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
require 'rails_helper'
require 'models/concerns/obcan_justice_sk/importable_spec'

RSpec.describe ObcanJusticeSk::CivilHearing, active_job: { adapter: :test } do
  it_behaves_like ObcanJusticeSk::Importable

  describe 'before save' do
    it 'anonymizes participants' do
      record = build(:obcan_justice_sk_civil_hearing, data: { 'navrhovatelia' => nil, 'odporcovia' => nil })

      expect { record.save! }.not_to(change { record.data })

      record =
        build(
          :obcan_justice_sk_civil_hearing,
          data: {
            'navrhovatelia' => [{ 'meno' => 'John Doe' }],
            'odporcovia' => [{ 'meno' => 'John Smith' }]
          }
        )

      record.save!

      expect(record.data['navrhovatelia'][0]['meno']).to match(/^[A-Z]\. [A-Z]\.$/)
      expect(record.data['odporcovia'][0]['meno']).to match(/^[A-Z]\. [A-Z]\.$/)

      record.reload

      expect(record.data['navrhovatelia'][0]['meno']).to match(/^[A-Z]\. [A-Z]\.$/)
      expect(record.data['odporcovia'][0]['meno']).to match(/^[A-Z]\. [A-Z]\.$/)
    end
  end

  describe 'after save' do
    let(:record) { build(:obcan_justice_sk_civil_hearing) }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileHearingJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileHearingJob).with(record).on_queue('reconcilers')
      expect { record.update!({}) }.to have_enqueued_job(ReconcileHearingJob).with(record).on_queue('reconcilers')
    end
  end
end
