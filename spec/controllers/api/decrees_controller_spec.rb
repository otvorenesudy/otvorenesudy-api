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
end
