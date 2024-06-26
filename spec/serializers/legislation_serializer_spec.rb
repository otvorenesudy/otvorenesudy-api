# == Schema Information
#
# Table name: legislations
#
#  id                :integer          not null, primary key
#  value             :string(510)      not null
#  value_unprocessed :string(510)      not null
#  type              :string(255)
#  number            :integer
#  year              :integer
#  name              :string(510)
#  section           :string(255)
#  paragraph         :string(255)
#  letter            :string(255)
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#
RSpec.describe LegislationSerializer do
  let(:adapter) { ActiveModel::Serializer.config.adapter.new(serializer) }
  let(:serializer) { described_class.new(legislation)  }

  describe '#external_url' do
    let(:legislation) { create(:legislation, value: 'Zakon 1 2 3', year: nil, number: nil) }

    context 'when metadata is present' do
      let(:legislation) { create(:legislation, value: 'Zakon 1 2 3', paragraph: '5', number: 3, letter: 'A', year: 2011, section: 3)  }

      it 'uses direct link to external legislation' do
        value = adapter.as_json[:legislation][:external_url]

        expect(value).to eql('http://www.zakonypreludi.sk/zz/2011-3#p5-3-A')
      end
    end

    context 'when there are no metadata' do
      it 'sets url as search link by legislation value' do
        value = adapter.as_json[:legislation][:external_url]

        expect(value).to eql('http://www.zakonypreludi.sk/main/search.aspx?text=Zakon 1 2 3')
      end
    end
  end
end
