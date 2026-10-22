# frozen_string_literal: true

require 'rails_helper'
require 'rake'

# Exports the maintainers run by hand (STORE=<directory> bin/rails export:decrees).
RSpec.describe 'export tasks', type: :task do
  let(:store) { Dir.mktmpdir }

  around do |example|
    ENV['STORE'] = store
    example.run
  ensure
    ENV.delete('STORE')
    FileUtils.rm_rf(store)
  end

  before do
    Rails.application.load_tasks unless Rake::Task.task_defined?('export:decrees')
  end

  def run(task)
    perform_enqueued_jobs { Rake::Task[task].tap(&:reenable).invoke }
  end

  describe 'export:decrees' do
    it 'writes the decrees, as the API gives them, in batches to a directory named by the time of the export' do
      decrees = create_list(:decree, 2)

      travel_to(Time.zone.parse('2024-03-05 14:30')) { run('export:decrees') }

      path = File.join(store, 'api-decrees-202403051430', "#{decrees.first.id}-#{decrees.last.id}.json")
      exported = JSON.parse(File.read(path))['decrees']

      expect(exported.pluck('id', 'ecli')).to eq(decrees.map { [it.id, it.ecli] })
    end
  end
end
