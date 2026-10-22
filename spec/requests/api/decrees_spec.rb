# frozen_string_literal: true

require 'rails_helper'

# The decrees API that otvorenesudy-prokuratura and outside callers read: what they get must stay byte for byte as it
# is. spec/fixtures/api/decree.json was recorded from the Rails 7.1 app.
RSpec.describe 'Decrees API' do
  let(:api_key) { create(:api_key).value }

  def json
    JSON.parse(response.body, symbolize_names: true)
  end

  def create_full_decree
    municipality = create(:municipality, name: 'Bratislava', zipcode: '812 44')
    court = create(:court, id: 1_000_001, name: 'Okresný súd Bratislava I', street: 'Záhradnícka 10', municipality:)
    decree = create(:decree, id: 1_000_002, court:, **decree_attributes)

    create_pages_and_judgements(decree)
    create_classification(decree)
    create_parties(decree)

    decree
  end

  def decree_attributes
    {
      uri: 'https://obcan.justice.sk/infosud/-/infosud/i-detail/rozhodnutie/abc',
      case_number: '1C/12/2023',
      file_number: '1123456789',
      ecli: 'ECLI:SK:OSBA1:2024:1123456789.1',
      date: Date.new(2024, 3, 1),
      form: create(:decree_form, value: 'Rozsudok', code: 'V')
    }
  end

  # Its text needs escaping in JSON; one judge matched exactly, and the same name twice inexactly.
  def create_pages_and_judgements(decree)
    create(:decree_page, decree:, number: 1, text: "Rozsudok v mene Slovenskej republiky <b>Š & \"ť\"</b> 'á' ")
    create(:decree_page, decree:, number: 2, text: "riadok\u2028ďalší > koniec")

    create(:judgement, decree:, judge: create(:judge, id: 1_000_003, last: 'Nováková'), judge_name_similarity: 1.0)
    create(:judgement, decree:, judge: nil, judge_name_similarity: 0.8, judge_name_unprocessed: 'JUDr. Kralik')
    create(:judgement, decree:, judge: nil, judge_name_similarity: 0.7, judge_name_unprocessed: 'JUDr. Kralik')
  end

  # A nature, legal areas, and two laws: one with its number, year and paragraph, one known only by its name.
  def create_classification(decree)
    create(:decree_naturalization, decree:, nature: create(:decree_nature, value: 'Konečné'))
    create(:legislation_area_usage, decree:, area: create(:legislation_area, value: 'Občianske právo'))
    create(:legislation_subarea_usage, decree:, subarea: create(:legislation_subarea, value: 'Nájom'))

    [
      { name: 'Občiansky zákonník', value: '40/1964 Zb. § 663', value_unprocessed: '§ 663', type: 'Zákon', year: 1964,
        number: 40, paragraph: '663', section: '1', letter: 'a' },
      { name: nil, value: 'Ústava SR', value_unprocessed: 'Ústava', type: nil, year: nil, number: nil, paragraph: nil,
        section: nil, letter: nil }
    ].each { |attributes| create(:legislation_usage, decree:, legislation: create(:legislation, **attributes)) }
  end

  # Two hearings of the decree's proceeding, sharing a proposer and a defendant.
  def create_parties(decree)
    [%w[Proposer Opponent Defendant], %w[Proposer Opponent2 Defendant]].each do |names|
      hearing = create(:hearing, proceeding: decree.proceeding, court: decree.court)

      create(:proposer, hearing:, name: names[0])
      create(:opponent, hearing:, name: names[1])
      create(:defendant, hearing:, name: names[2])
    end
  end

  describe 'GET /decrees/:id.json' do
    it 'returns the decree with everything about it, as it always has' do
      travel_to(Time.zone.parse('2024-03-05 14:30:15.123456'), with_usec: true) { create_full_decree }

      get "/decrees/1000002.json?api_key=#{api_key}"

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq('application/json')
      expect(response.body).to eq(file_fixture('api/decree.json').read.chomp)
    end

    it 'lists no parties for a decree outside any proceeding' do
      decree = create(:decree, proceeding: nil)

      get "/decrees/#{decree.id}.json?api_key=#{api_key}"

      expect(json[:decree].slice(:proposers, :opponents,
                                 :defendants)).to eq(proposers: [], opponents: [], defendants: [])
    end

    it 'says a decree that does not exist does not exist' do
      get "/decrees/20000001.json?api_key=#{api_key}"

      expect(response).to have_http_status(:not_found)
      expect(response.body).to eq('{"success":false,"errors":["Resource does not exist."]}')
    end

    it 'refuses a caller without a valid API key' do
      decree = create(:decree)

      get "/decrees/#{decree.id}.json?api_key=bogus"

      expect(response).to have_http_status(:unauthorized)
      expect(response.body).to eq('{"success":false,"errors":["Invalid API Key"]}')
    end

    it 'refuses a caller without an API key' do
      decree = create(:decree)

      get "/decrees/#{decree.id}.json"

      expect(response).to have_http_status(:unauthorized)
      expect(json).to eq(success: false, errors: ['Invalid API Key'])
    end
  end

  describe 'GET /decrees/sync.json' do
    let!(:decrees) do
      Array.new(101) { |n| create(:decree, updated_at: Time.zone.parse('2024-01-01 10:00') + (n % 7).minutes) }
           .sort_by { |decree| [decree.updated_at, decree.id] }
    end

    it 'returns the first 100 decrees by when they changed, and links to the rest' do
      get "/decrees/sync.json?api_key=#{api_key}"

      last = decrees[99]
      since = CGI.escape(last.updated_at.as_json)

      expect(response.headers['Content-Type']).to eq('application/json; charset=utf-8')
      expect(json[:decrees].pluck(:id)).to eq(decrees.first(100).map(&:id))
      expect(response.headers['Link']).to eq(
        "<http://www.example.com/decrees/sync.json?api_key=#{api_key}&last_id=#{last.id}&since=#{since}>; rel='next'"
      )
    end

    it 'follows the link to the decrees after the last one, and ends there' do
      get "/decrees/sync.json?api_key=#{api_key}"
      get response.headers['Link'][/<(.+)>/, 1]

      expect(json[:decrees].pluck(:id)).to eq([decrees.last.id])
      expect(response.headers['Link']).to be_nil
    end

    it 'returns the decrees changed since a time' do
      later = Array.new(3) { create(:decree, updated_at: Time.zone.parse('2024-02-01 10:00')) }

      get "/decrees/sync.json?api_key=#{api_key}&since=#{CGI.escape('2024-01-31T00:00:00.000+01:00')}"

      expect(json[:decrees].pluck(:id)).to eq(later.map(&:id))
      expect(response.headers['Link']).to be_nil
    end

    it 'answers a time it cannot read with what is wrong, rather than with no decrees' do
      get "/decrees/sync.json?api_key=#{api_key}&since=yesterday"

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq('{"success":false,"errors":["Invalid since: yesterday"]}')
    end

    it 'answers a date that cannot exist with what is wrong' do
      get "/decrees/sync.json?api_key=#{api_key}&since=2024-13-01"

      expect(response).to have_http_status(:bad_request)
      expect(response.body).to eq('{"success":false,"errors":["Invalid since: 2024-13-01"]}')
    end

    it 'returns the same decrees as the decree endpoint does' do
      get "/decrees/sync.json?api_key=#{api_key}"
      listed = json[:decrees].first

      get "/decrees/#{decrees.first.id}.json?api_key=#{api_key}"

      expect(json[:decree]).to eq(listed)
    end

    it 'refuses a caller without a valid API key' do
      get '/decrees/sync.json?api_key=bogus'

      expect(response).to have_http_status(:unauthorized)
      expect(json).to eq(success: false, errors: ['Invalid API Key'])
    end
  end

  describe 'GET /decrees/health.json' do
    it 'reports success when decrees changed within two days' do
      create(:decree, updated_at: 20.days.ago)
      create(:decree, updated_at: 3.hours.ago)

      get "/decrees/health.json?api_key=#{api_key}"

      expect(response).to have_http_status(:ok)
      expect(response.body).to eq('{"status":"Success"}')
    end

    it 'reports failure when no decree changed within two days' do
      create(:decree, updated_at: 20.days.ago)

      get "/decrees/health.json?api_key=#{api_key}"

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.body).to eq('{"status":"Failure"}')
    end

    it 'allows three days on a Monday, after the weekend' do
      create(:decree, updated_at: Time.zone.parse('2019-01-18 06:00'))

      travel_to(Time.zone.parse('2019-01-21 00:00')) { get "/decrees/health.json?api_key=#{api_key}" }

      expect(response).to have_http_status(:ok)
    end

    it 'reports failure on a Monday when nothing changed for more than three days' do
      create(:decree, updated_at: Time.zone.parse('2019-01-17 06:00'))

      travel_to(Time.zone.parse('2019-01-21 00:00')) { get "/decrees/health.json?api_key=#{api_key}" }

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'refuses a caller without a valid API key' do
      get '/decrees/health.json'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
