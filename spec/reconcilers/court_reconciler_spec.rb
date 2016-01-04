require 'rails_helper'

RSpec.describe CourtReconciler do
  subject { CourtReconciler.new(court, mapper: mapper) }

  let(:court) { double(:court) }
  let(:mapper) { double(:mapper, attributes) }
  let(:attributes) {
    {
      uri: 'http://path/to/file',
      name: 'Example Court',
      street: 'Example Avenue 45',
      phone: '+421 000 000 000',
      fax: '123456',
      media_person: 'Peter Parker',
      media_phone: nil,
      latitude: 48.11,
      longitude: 49.12,
      type: 'Court Type',
      municipality: 'Bratislava',
      zipcode: '12345',
      acronym: 'OSBA1',

      information_center_email: 'podatelnaosba1@justice.sk',
      information_center_phone: nil,
      information_center_hours: [],
      information_center_note: nil,

      registry_center_phone: '02/88 811 180, fax 02/88 811 192',
      registry_center_email: nil,
      registry_center_hours: [],
      registry_center_note: nil,

      business_registry_center_phone: '02/50 118 340, 02/50 118 356, 02/50 118 181, 02/50 118 421',
      business_registry_center_email: nil,
      business_registry_center_hours: [],
      business_registry_center_note: nil
    }
  }

  describe '#reconcile!' do
    it 'runs all reconciliations' do
      expect(court).to receive(:with_lock).and_yield

      expect(subject).to receive(:reconcile_attributes).ordered
      expect(subject).to receive(:reconcile_type).ordered
      expect(subject).to receive(:reconcile_municipality).ordered
      expect(subject).to receive(:reconcile_information_center).ordered
      expect(subject).to receive(:reconcile_registry_center).ordered
      expect(subject).to receive(:reconcile_business_registry_center).ordered

      expect(court).to receive(:save!).ordered
      expect(court).to receive(:touch).ordered

      subject.reconcile!
    end
  end

  describe '#reconcile_attributes' do
    it 'reconciles attributes for court' do
      allow(Source).to receive(:find_by).with(module: 'JusticeGovSk') { :source }

      expect(court).to receive(:assign_attributes).with(
        attributes.slice(:uri, :name, :street, :phone, :fax, :media_person, :media_phone, :longitude, :latitude, :acronym).merge(source: :source)
      )

      subject.reconcile_attributes
    end
  end

  describe '#reconcile_type' do
    it 'reconciles court type' do
      allow(Court::Type).to receive(:find_by).with(value: 'Court Type') { :type }
      expect(court).to receive(:type=).with(:type)

      subject.reconcile_type
    end
  end

  describe '#reconcile_municipality' do
    let(:municipality) { double(:municipality) }

    it 'reconciles court municipality' do
      allow(Municipality).to receive(:find_or_initialize_by).with(name: 'Bratislava') { municipality }
      expect(municipality).to receive(:assign_attributes).with(zipcode: '12345')
      expect(court).to receive(:municipality=).with(municipality)

      subject.reconcile_municipality
    end
  end

  describe '#reconcile_information_center' do
    let(:office) { double(:office) }

    it 'reconciles information center' do
      allow(Court::Office::Type).to receive(:find_by).with(value: 'Informačné centrum') { :type }
      allow(Court::Office).to receive(:find_or_initialize_by).with(court: court, type: :type) { office }

      expect(court).to receive(:information_center=).with(office)
      expect(office).to receive(:assign_attributes).with(
        email: 'podatelnaosba1@justice.sk',
        phone: nil,
        hours_monday: nil,
        hours_tuesday: nil,
        hours_wednesday: nil,
        hours_thursday: nil,
        hours_friday: nil,
        note: nil
      )

      subject.reconcile_information_center
    end

    context 'when no attributes are present' do
      let(:attributes) {
        {
          information_center_email: nil,
          information_center_phone: nil,
          information_center_hours: [],
          information_center_note: nil,
        }
      }

      it 'does not reconcile information center' do
        expect(Court::Office::Type).not_to receive(:find_by)
        expect(Court::Office).not_to receive(:find_or_initialize_by)

        subject.reconcile_information_center
      end
    end
  end

  describe '#reconcile_registry_center' do
    let(:office) { double(:office) }

    it 'reconciles registry center' do
      allow(Court::Office::Type).to receive(:find_by).with(value: 'Podateľna') { :type }
      allow(Court::Office).to receive(:find_or_initialize_by).with(court: court, type: :type) { office }

      expect(court).to receive(:registry_center=).with(office)
      expect(office).to receive(:assign_attributes).with(
        email: nil,
        phone: '02/88 811 180, fax 02/88 811 192',
        hours_monday: nil,
        hours_tuesday: nil,
        hours_wednesday: nil,
        hours_thursday: nil,
        hours_friday: nil,
        note: nil
      )

      subject.reconcile_registry_center
    end

    context 'when no attributes are present' do
      let(:attributes) {
        {
          registry_center_email: nil,
          registry_center_phone: nil,
          registry_center_hours: [],
          registry_center_note: nil,
        }
      }

      it 'does not reconcile registry center' do
        expect(Court::Office::Type).not_to receive(:find_by)
        expect(Court::Office).not_to receive(:find_or_initialize_by)

        subject.reconcile_registry_center
      end
    end
  end

  describe '#reconcile_business_registry_center' do
    let(:office) { double(:office) }

    it 'reconciles business registry center' do
      allow(Court::Office::Type).to receive(:find_by).with(value: 'Informačné stredisko obchodného registra') { :type }
      allow(Court::Office).to receive(:find_or_initialize_by).with(court: court, type: :type) { office }

      expect(court).to receive(:business_registry_center=).with(office)
      expect(office).to receive(:assign_attributes).with(
        email: nil,
        phone: '02/50 118 340, 02/50 118 356, 02/50 118 181, 02/50 118 421',
        hours_monday: nil,
        hours_tuesday: nil,
        hours_wednesday: nil,
        hours_thursday: nil,
        hours_friday: nil,
        note: nil
      )

      subject.reconcile_business_registry_center
    end

    context 'when no attributes are present' do
      let(:attributes) {
        {
          business_registry_center_email: nil,
          business_registry_center_phone: nil,
          business_registry_center_hours: [],
          business_registry_center_note: nil,
        }
      }

      it 'does not reconcile business registry center' do
        expect(Court::Office::Type).not_to receive(:find_by)
        expect(Court::Office).not_to receive(:find_or_initialize_by)

        subject.reconcile_business_registry_center
      end
    end
  end
end
