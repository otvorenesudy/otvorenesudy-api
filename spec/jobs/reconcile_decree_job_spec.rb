# frozen_string_literal: true

require 'rails_helper'

# A decree as obcan.justice.sk publishes it becomes an Open Courts decree, with the text of its document: the import
# stores the record, which enqueues ReconcileDecreeJob with it, and the job writes the decree and asks otvorenesudy to
# reindex it. The document is fetched from obcan.justice.sk, faked here.
RSpec.describe ReconcileDecreeJob do
  let(:document_url) { 'https://obcan.justice.sk/content/public/item/3855d4dc-1209-4ddf-8a63-34cb3349cede' }
  let(:decree) { Decree.find_by!(ecli: 'ECLI:SK:OSLC:2021:6120386527.2') }
  let(:judge) do
    create(:judge, name: 'JUDr. Andrea Gabrielová', source_class: 'ObcanJusticeSk::Judge',
                   source_class_id: create(:obcan_justice_sk_judge, guid: 'sudca_831').id)
  end

  before do
    create_lookups
    create(:court, name: 'Okresný súd Lučenec')
    judge
    stub_request(:get, document_url).to_return(body: file_fixture('pdf/normal.pdf').binread)
  end

  def payload
    JSON.parse(file_fixture('obcan_justice_sk/mappers/decree.json').read)
  end

  def import(data)
    perform_enqueued_jobs do
      ObcanJusticeSk::Decree.import_from!(guid: data.fetch('guid'), uri: 'https://obcan.justice.sk/rozhodnutie', data:)
    end
  end

  it 'writes the decree with its court, form, proceeding and judge, and asks otvorenesudy to reindex it' do
    import(payload)

    expect(decree).to have_attributes(
      uri: 'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/rozhodnutia/819aef78-bdd4-4855-b8ed-d936446d41a2:' \
           '3855d4dc-1209-4ddf-8a63-34cb3349cede',
      case_number: '17Csp/50/2021', file_number: '6120386527', date: Date.new(2021, 5, 27), pdf_uri: document_url,
      source_class: 'ObcanJusticeSk::Decree'
    )
    expect([decree.court.name, decree.form.value, decree.proceeding.file_number, decree.judges.to_a])
      .to eq(['Okresný súd Lučenec', 'Rozsudok', '6120386527', [judge]])
    expect(Sidekiq::Queues['probe'].pluck('args')).to eq([['Decree', decree.id]])
  end

  it 'classifies the decree by its areas of law, its nature and the laws it refers to' do
    import(payload)

    expect(decree.legislation_areas.pluck(:value)).to eq(['Občianske právo'])
    expect(decree.legislation_subareas.pluck(:value)).to eq(['Spotrebiteľské zmluvy'])
    expect(decree.natures.pluck(:value)).to eq(['Prvostupňové nenapadnuté opravnými prostriedkami'])
    expect(decree.legislations.order(:id).pluck(:year, :number, :paragraph, :section)).to eq(
      [[1964, 40, nil, nil], [1964, 40, '52', '1'], [1964, 40, '52', '2'], [1964, 40, '517', '1'],
       [1964, 40, '517', '2'], [2005, 300, '289', '1']]
    )
  end

  it 'keeps the text of each page of the document' do
    import(payload)

    expect(decree.pages.order(:number).pluck(:number, :text)).to eq([[1, 'Dummy PDF file']])
  end

  it 'keeps no pages of a scanned document without text' do
    stub_request(:get, document_url).to_return(body: file_fixture('pdf/ocr.pdf').binread)

    import(payload)

    expect(decree.pages).to be_empty
  end

  it 'updates the same decree when the record changes, dropping what it no longer lists' do
    import(payload)
    import(payload.merge('povaha' => [], 'odkazovanePredpisy' => [payload['odkazovanePredpisy'].first]))

    expect(Decree.where(ecli: 'ECLI:SK:OSLC:2021:6120386527.2').count).to eq(1)
    expect(decree.natures).to be_empty
    expect(decree.legislations.pluck(:year, :number, :paragraph)).to eq([[1964, 40, nil]])
  end

  it 'updates the decree of the same ECLI that otvorenesudy holds under another address' do
    existing = create(:decree, ecli: 'ECLI:SK:OSLC:2021:6120386527.2', uri: 'https://www.justice.gov.sk/old')

    import(payload)

    expect(Decree.where(ecli: 'ECLI:SK:OSLC:2021:6120386527.2').pluck(:id, :case_number))
      .to eq([[existing.id, '17Csp/50/2021']])
  end
end
