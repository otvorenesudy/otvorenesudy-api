require 'rails_helper'
require 'controllers/concerns/api/authorizable_spec'
require 'controllers/concerns/api/syncable_spec'

RSpec.describe Api::DecreesController do
  let(:api_key) { create :api_key }
  let(:decree) { create(:decree) }
  let(:judges) { 2.times.map { create(:judge) } }

  it_behaves_like Api::Authorizable
  it_behaves_like Api::Syncable do
    let(:repository) { Decree }
    let(:url)        { ->(*args) { sync_api_decrees_url(*args) } }
  end

  describe 'GET /sync' do
    it 'fetches inexact judges as scopes correctly' do
      create :judgement, decree: decree, judge: judges[0], judge_name_similarity: 0.8, judge_name_unprocessed: 'JuDR. Kralik'
      create :judgement, decree: decree, judge: judges[1], judge_name_similarity: 1.0

      get :sync, params: { api_key: api_key.value }, format: :json

      json = JSON.parse(response.body, symbolize_names: true)

      expect(json[:decrees][0][:judges]).to eql([
        {
          id: judges[1].id,
          name: judges[1].name
        }
      ])
      expect(json[:decrees][0][:other_judges]).to eql(['JuDR. Kralik'])
    end
  end

  describe '/health' do
    let!(:decree) do
      create :decree, updated_at: 20.days.ago.beginning_of_day
    end

    context 'with any decrees updated recently' do
      it 'returns success' do
        create :decree, updated_at: 3.hours.ago

        get :health, params: { api_key: api_key.value }, format: :json

        expect(response.status).to eql(200)
        expect(JSON.parse(response.body, symbolize_names: true)).to eql(
          status: 'Success'
        )
      end
    end

    context 'without any decrees updated recently' do
      it 'returns failure' do
        get :health, params: { api_key: api_key.value }, format: :json

        expect(response.status).to eql(422)
        expect(JSON.parse(response.body, symbolize_names: true)).to eql(
          status: 'Failure'
        )
      end
    end

    context 'with any decrees not updated during weekend no more than 3 days' do
      let(:time) { Time.zone.parse('2019-01-18 06:00') }
      let!(:decree) { create :decree, updated_at: time }

      it 'returns success' do
        Timecop.travel Time.parse('2019-01-21 00:00') do
          get :health, params: { api_key: api_key.value }, format: :json

          expect(response.status).to eql(200)
          expect(JSON.parse(response.body, symbolize_names: true)).to eql(
            status: 'Success'
          )
        end
      end
    end

    context 'with any decrees not updated during weekend more than 3 days' do
      let(:time) { Time.zone.parse('2019-01-17 06:00') }
      let!(:decree) { create :decree, updated_at: time }

      it 'returns success' do
        Timecop.travel Time.parse('2019-01-21 00:00') do
          get :health, params: { api_key: api_key.value }, format: :json

          expect(response.status).to eql(422)
          expect(JSON.parse(response.body, symbolize_names: true)).to eql(
            status: 'Failure'
          )
        end
      end
    end
  end
end
