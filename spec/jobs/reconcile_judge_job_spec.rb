# frozen_string_literal: true

require 'rails_helper'

# A judge as obcan.justice.sk publishes it becomes an Open Courts judge, employed at the courts the record names: the
# import stores the record, which enqueues ReconcileJudgeJob with it, and the job writes the judge and asks
# otvorenesudy to reindex them.
RSpec.describe ReconcileJudgeJob do
  let(:supreme_court) { create(:court, name: 'Najvyšší súd Slovenskej republiky') }
  let(:nitra) { create(:court, name: 'Krajský súd Nitra') }
  let(:judge) { Judge.find_by!(name: 'JUDr. Alena Adamcová') }

  before do
    create_lookups
    supreme_court
    nitra
  end

  def payload
    JSON.parse(file_fixture('obcan_justice_sk/mappers/judge.json').read)
  end

  def import(data)
    perform_enqueued_jobs do
      ObcanJusticeSk::Judge.import_from!(guid: data.fetch('registreGuid'), uri: 'https://obcan.justice.sk/sudca/1',
                                         data:)
    end
  end

  def employments
    judge.employments.order(:id).map do |employment|
      [employment.court.name, employment.position.value, employment.active]
    end
  end

  # A court record that lists the judge (id 1) in its judicial council.
  def import_court_with_council(role)
    data = JSON.parse(file_fixture('obcan_justice_sk/mappers/court.json').read)
               .merge(role => { 'sudcovia' => [{ 'id' => '1', 'meno' => 'JUDr. Alena ADAMCOVÁ' }] })

    ObcanJusticeSk::Court.import_from!(guid: 'sud_102', uri: 'https://obcan.justice.sk/sud/sud_102', data:)
  end

  it 'writes the judge with the parts of their name, and asks otvorenesudy to reindex them' do
    import(payload)

    expect(judge).to have_attributes(
      uri: 'https://www.justice.gov.sk/sudy-a-rozhodnutia/sudy/sudcovia/sudca_1',
      name_unprocessed: 'JUDr. Alena ADAMCOVÁ', prefix: 'JUDr.', first: 'Alena', last: 'Adamcová',
      source_class: 'ObcanJusticeSk::Judge'
    )
    expect(Sidekiq::Queues['probe'].pluck('args')).to eq([['Judge', judge.id]])
  end

  it 'employs the judge at their court with their position and status, and at the court they are assigned to' do
    import(payload)

    expect(employments).to eq(
      [['Najvyšší súd Slovenskej republiky', 'sudca', true], ['Krajský súd Nitra', 'sudca', true]]
    )
    expect(judge.employments.find_by!(court: supreme_court).status).to eq('active')
  end

  it 'employs the judge at their court alone when the record assigns them nowhere else' do
    import(payload.merge('docasnePridelenySud' => { 'registreGuid' => nil, 'nazov' => nil }))

    expect(employments).to eq([['Najvyšší súd Slovenskej republiky', 'sudca', true]])
  end

  it 'employs the judge as the chairman of the judicial council of a court that lists them so' do
    bratislava = create(:court, name: 'Mestský súd Bratislava I')
    import_court_with_council('srPredseda')

    import(payload)

    expect(judge.employments.find_by!(court: bratislava).position.value).to eq('predseda súdnej rady')
  end

  it 'employs the judge as a member of the judicial council of a court that lists them so' do
    bratislava = create(:court, name: 'Mestský súd Bratislava I')
    import_court_with_council('srClen')

    import(payload)

    expect(judge.employments.find_by!(court: bratislava).position.value).to eq('člen súdnej rady')
  end

  it 'ends the employments the record no longer names, and updates the ones it does' do
    import(payload)
    import(payload.merge('stav' => 'label.sudca.odvolany', 'docasnePridelenySud' => payload['sud']))

    expect(employments).to eq(
      [['Najvyšší súd Slovenskej republiky', 'sudca', false], ['Krajský súd Nitra', 'sudca', false]]
    )
    expect(judge.employments.find_by!(court: supreme_court).status).to eq('terminated')
  end
end
