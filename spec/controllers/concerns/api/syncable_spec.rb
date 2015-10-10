require 'rails_helper'

RSpec.shared_examples_for Api::Syncable do
  let(:api_key) { create :api_key }
  let(:factory) { repository.name.underscore.to_sym }
  let!(:records) { 101.times.map { FactoryGirl.create(factory) }.sort_by { |r| [r.updated_at, r.id] }}
  let(:adapter) { ActiveModel::Serializer.config.adapter }

  describe 'GET sync' do
    it 'returns records as json' do
      serializer = ActiveModel::Serializer::ArraySerializer.new(
        records.first(100),
        serializer: "#{repository}Serializer".constantize
      )

      json = adapter.new(serializer).to_json

      get :sync, params: { api_key: api_key.value }, format: :json

      expect(response.headers['Content-Type']).to eql('application/json; charset=utf-8')
      expect(response.body).to eql(json)
    end

    it 'returns records sorted by updated_at and id' do
      get :sync, params: { api_key: api_key.value }, format: :json

      result = assigns(:records)

      expect(result.to_a).to eql(records.first(100))
    end

    it 'provides hypermedia API' do
      get :sync, params: { api_key: api_key.value }, format: :json

      link = url.call(since: records[99].updated_at.as_json, last_id: records[99].id, api_key: api_key.value)

      expect(response.headers['Link']).to eql("<#{link}>; rel='next'")
      expect(response.headers['Link']).to match('/sync.json?')
    end

    context 'with since parameter' do
      it 'returns records updated after provided date' do
        date = Time.now + 2.days

        other = 3.times.map { FactoryGirl.create factory, updated_at: date }

        get :sync, params: { since: date.as_json, api_key: api_key.value }, format: :json

        result = assigns(:records)

        expect(result.to_a).to eql(other)
      end
    end

    context 'when last request' do
      it 'does not embed Link header' do
        date = Time.now + 2.days

        3.times.map { FactoryGirl.create factory, updated_at: date }

        get :sync, params: { api_key: api_key.value }, format: :json
        get :sync, params: { since: date.as_json, api_key: api_key.value }, format: :json

        expect(response.headers['Link']).to be_nil
      end
    end
  end
end
