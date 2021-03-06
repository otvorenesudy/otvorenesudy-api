require 'spec_helper'
require 'obcan_justice_sk'

RSpec.describe ObcanJusticeSk::Judges::ResourceParser do
  let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_587' }
  let(:html) { ObcanJusticeSk::Downloader.download(uri) }
  let(:attributes) { ObcanJusticeSk::Judges::ResourceParser.parse(html) }

  describe '.parse' do
    it 'parses judge attributes', vcr: { cassette_name: 'obcan_justice_sk/judge' } do
      expect(attributes).to eql(
        meno: 'JUDr. Ivan ALMAN',
        sud: 'Okresný súd Bratislava IV',
        sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/105',
        docasny_sud: nil,
        docasny_sud_uri: nil,
        aktivny: true,
        poznamka: nil
      )
    end

    context 'when judge is inactive' do
      let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_893' }

      it 'parses inactivity correctly', vcr: { cassette_name: 'obcan_justice_sk/inactive_judge' } do
        expect(attributes).to eql(
          meno: 'JUDr. Jana ÁRENDÁŠOVÁ',
          sud: 'Okresný súd Nitra',
          sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/124',
          docasny_sud: nil,
          docasny_sud_uri: nil,
          aktivny: false,
          poznamka: '- od 1. augusta 2010 má prerušený výkon funkcie sudcu podľa § 24 ods. 4 zákona č. 385/2000 Z.z.'
        )
      end
    end

    context 'when judge is temporarily assgined to another court' do
      let(:uri) { 'https://obcan.justice.sk/infosud/-/infosud/reg-detail/sudca/sudca_258' }

      it 'parses temporary court correctly', vcr: { cassette_name: 'obcan_justice_sk/judge_with_temporary_court' } do
        expect(attributes).to eql(
          meno: 'JUDr. Jozef ANGELOVIČ',
          sud: 'Krajský súd v Prešove',
          sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/155',
          docasny_sud: 'Najvyšší súd Slovenskej republiky',
          docasny_sud_uri: 'https://obcan.justice.sk/infosud/-/infosud/detail/sud/100',
          aktivny: true,
          poznamka: nil
        )
      end
    end
  end
end
