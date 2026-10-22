# frozen_string_literal: true

# == Schema Information
#
# Table name: obcan_justice_sk_judges
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

RSpec.describe ObcanJusticeSk::Judge do
  it_behaves_like ObcanJusticeSk::Importable

  describe 'after save' do
    let(:record) { build(:obcan_justice_sk_judge) }

    it 'enqueues reconciliation job' do
      expect { record }.not_to have_enqueued_job(ReconcileJudgeJob).on_queue('reconcilers')
      expect { record.save! }.to have_enqueued_job(ReconcileJudgeJob).with(record).on_queue('reconcilers')
      expect { record.update!({}) }.to have_enqueued_job(ReconcileJudgeJob).with(record).on_queue('reconcilers')
    end
  end

  describe '#courts_as_judicial_council_chairman' do
    let!(:chairman) { create(:obcan_justice_sk_judge, data: { 'registreGuid' => 'sudca_1' }) }

    let!(:court) do
      create(
        :obcan_justice_sk_court,
        data: {
          'srPredseda' => {
            'sudcovia' => [{ 'id' => chairman.data['registreGuid'].delete_prefix('sudca_') }]
          },
          'srClen' => {
            'sudcovia' => [{ 'id' => '2' }]
          }
        }
      )
    end

    before do
      create_list(:obcan_justice_sk_judge, 2).tap do |judges|
        create(
          :obcan_justice_sk_court,
          data: {
            'srPredseda' => {
              sudcovia: [{ 'id' => judges[0].data['registreGuid'].delete_prefix('sudca_') }]
            },
            'srClen' => {
              sudcovia: [{ 'id' => judges[1].data['registreGuid'].delete_prefix('sudca_') }]
            }
          }
        )
      end
    end

    it 'returns courts where the judge is a chairman' do
      expect(chairman.courts_as_judicial_council_chairman).to contain_exactly(court)
    end
  end

  describe '#courts_as_judicial_council_member' do
    let!(:chairman) { create(:obcan_justice_sk_judge, data: { 'registreGuid' => 'sudca_1' }) }

    let!(:court) do
      create(
        :obcan_justice_sk_court,
        data: {
          'srPredseda' => {
            'sudcovia' => [{ 'id' => '123' }]
          },
          'srClen' => {
            'sudcovia' => [{ 'id' => chairman.data['registreGuid'].delete_prefix('sudca_') }]
          }
        }
      )
    end

    before do
      create_list(:obcan_justice_sk_judge, 2).tap do |judges|
        create(
          :obcan_justice_sk_court,
          data: {
            'srPredseda' => {
              sudcovia: [{ 'id' => judges[0].data['registreGuid'].delete_prefix('sudca_') }]
            },
            'srClen' => {
              sudcovia: [{ 'id' => judges[1].data['registreGuid'].delete_prefix('sudca_') }]
            }
          }
        )
      end
    end

    it 'returns courts where the judge is a member' do
      expect(chairman.courts_as_judicial_council_member).to contain_exactly(court)
    end
  end
end
