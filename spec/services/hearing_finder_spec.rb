require 'rails_helper'

RSpec.describe HearingFinder do
  describe '.find_by' do
    it 'finds hearing by uri' do
      hearing = create(:hearing, uri: 'uri')
      attributes = double(uri: 'uri')

      expect(HearingFinder.find_by(attributes)).to eql(hearing)
    end

    context 'when hearing is not saved with uri' do
      it 'finds hearing by unique attribute combination' do
        Timecop.freeze do
          hearing = create(:hearing, uri: 'other uri', date: 2.days.ago, file_number: '12345', court: create(:court, name: 'Sud'))
          attributes = double(uri: 'uri', date: 2.days.ago, file_number: '12345', court: 'Sud',  judges: ['Peter Pan'], chair_judges: [])

          create(:judging, hearing: hearing, judge: create(:judge, name: 'Peter Pan'))
          create(:hearing, date: 2.days.ago, file_number: '123')

          expect(HearingFinder.find_by(attributes)).to eql(hearing)
        end
      end
    end
  end
end
