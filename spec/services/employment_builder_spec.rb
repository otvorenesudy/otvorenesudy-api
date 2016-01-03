require 'spec_helper'
require_relative '../../app/services/employment_builder'

RSpec.describe EmploymentBuilder do
  describe '.build' do
    let(:association) { double(:association) }
    let(:position) { double(:position) }
    let(:court) { double(:court) }
    let(:employment) { double(:employment, new_record?: true) }

    it 'builds employment' do
      allow(association).to receive(:find_or_initialize_by).with(court: court, position: position) { employment }
      expect(employment).to receive(:active=).with(true)

      EmploymentBuilder.build_or_update(association, position: position, court: court, active: true)
    end

    context 'when record is not new' do
      let(:employment) { double(:employment, new_record?: false) }

      it 'saves it' do
        allow(association).to receive(:find_or_initialize_by).with(court: court, position: position) { employment }
        expect(employment).to receive(:active=).with(true)
        expect(employment).to receive(:save!)

        EmploymentBuilder.build_or_update(association, position: position, court: court, active: true)
      end
    end
  end
end
