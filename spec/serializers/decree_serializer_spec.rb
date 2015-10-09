require 'rails_helper'

RSpec.describe DecreeSerializer do
  let(:adapter) { ActiveModel::Serializer.config.adapter }
  let(:serializer) { described_class }

  context 'with json serializer' do
    it 'serializes decree correctly' do
      municipality = create(:municipality, name: 'Bratislava', zipcode: '123 45')
      court = create(:court, name: 'Krajský súd Bratislava', street: 'Kozia 20 3/4', municipality: municipality)

      area = create(:legislation_area, value: 'Občianske právo')
      subarea = create(:legislation_subarea, value: 'Majetok', area: area)
      form = create(:decree_form, value: 'Platobný príkaz', code: 'P')

      decree = create(:decree,
        id: 3,
        uri: 'http://justice.gov.sk/3',
        case_number: '2007',
        file_number: '12345678',
        ecli: 'ecli',
        date: Time.utc(2013, 4, 1, 13, 0),

        court: court,
        form: form,

        legislation_area: area,
        legislation_subarea: subarea,
      )

      create(:decree_page, decree: decree, number: 1, text: 'Text 1 ')
      create(:decree_page, decree: decree, number: 2, text: 'Text 2 ')
      create(:decree_page, decree: decree, number: 3, text: 'Text 3')

      nature = create(:decree_nature, value: 'Zastavujúce odvolacie konanie')
      create(:decree_naturalization, decree: decree, nature: nature)

      judge = create(:judge, first: 'Peter', last: 'Harabin')
      create(:judgement, judge: judge, decree: decree)

      legislation = create(:legislation,
        name: 'Legislation #1',
        year: 2011,
        number: 3,
        section: 2,
        paragraph: 4,
        letter: 'A',
        type: 'Zákon',
        value: 'Value',
        value_unprocessed: 'Unprocessed Value'
      )
      create(:legislation_usage, legislation: legislation, decree: decree)

      hash = adapter.new(serializer.new(decree)).as_json

      expect(hash).to eql({
        decree: {
          id: decree.id,
          case_number: '2007',
          file_number: '12345678',
          ecli: 'ecli',
          text: 'Text 1 Text 2 Text 3',
          date: Time.parse('2013-04-01').to_date,
          uri: 'http://justice.gov.sk/3',
          document_url: 'http://otvorenesudy.sk/decrees/3/document',
          created_at: decree.created_at,
          updated_at: decree.updated_at,
          court: {
            id: decree.court.id,
            name: 'Krajský súd Bratislava',
            address: 'Kozia 20 3/4, 123 45 Bratislava'
          },
          form: {
            code: 'P',
            value: 'Platobný príkaz'
          },
          legislation_area: {
            value: 'Občianske právo'
          },
          legislation_subarea: {
            value: 'Majetok'
          },
          natures: [
            {
              value: 'Zastavujúce odvolacie konanie'
            }
          ],
          judges: [
            {
              id: judge.id,
              name: 'JUDr. Peter Harabin, PhD.'
            }
          ],
          legislations: [
            {
              name: 'Legislation #1',
              number: 3,
              letter: 'A',
              paragraph: '4',
              section: '2',
              type: 'Zákon',
              year: 2011,
              value: 'Value',
              value_unprocessed: 'Unprocessed Value',
              external_url: 'http://www.zakonypreludi.sk/zz/2011-3#p4-2-A'
            }
          ],

          defendants: [],
          opponents: [],
          proposers: []
        }
      })
    end
  end
end
