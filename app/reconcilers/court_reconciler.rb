class CourtReconciler
  attr_reader :source, :court

  def initialize(source, court)
    @source = source
    @court = court
  end

  def reconcile
    reconcile_attributes
    reconcile_type
    reconcile_municipality
    reconcile_information_center
    reconcile_registry_center
    reconcile_business_registry_center
  end

  def reconcile_attributes
    court.assign_attributes(
      uri: source.uri,
      name: source.name,
      street: source.street,
      phone: source.phone,
      fax: source.fax,
      media_person: source.media_person,
      media_phone: source.media_phone,
      latitude: source.latitude,
      longitude: source.longitude
    )
  end

  def reconcile_type
    court.type = Court::Type.find_by(value: source.type)
  end

  def reconcile_municipality
    court.municipality = Municipality.find_or_initialize_by(name: source.municipality, zipcode: source.zipcode)
  end

  def reconcile_information_center
    attributes = {
      email: source.information_center_email,
      phone: source.information_center_phone,
      hours_monday: source.information_center_hours[0],
      hours_tuesday: source.information_center_hours[1],
      hours_wednesday: source.information_center_hours[2],
      hours_thursday: source.information_center_hours[3],
      hours_friday: source.information_center_hours[4],
      note: source.information_center_note
    }

    return unless attributes.compact.any?

    type = Court::Office::Type.find_by(value: 'Informačné centrum')
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)
    court.information_center = office
  end

  def reconcile_registry_center
    attributes = {
      email: source.registry_center_email,
      phone: source.registry_center_phone,
      hours_monday: source.registry_center_hours[0],
      hours_tuesday: source.registry_center_hours[1],
      hours_wednesday: source.registry_center_hours[2],
      hours_thursday: source.registry_center_hours[3],
      hours_friday: source.registry_center_hours[4],
      note: source.registry_center_note
    }

    return unless attributes.compact.any?

    type = Court::Office::Type.find_by(value: 'Podateľna')
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)
    court.registry_center = office
  end

  def reconcile_business_registry_center
    attributes = {
      email: source.business_registry_center_email,
      phone: source.business_registry_center_phone,
      hours_monday: source.business_registry_center_hours[0],
      hours_tuesday: source.business_registry_center_hours[1],
      hours_wednesday: source.business_registry_center_hours[2],
      hours_thursday: source.business_registry_center_hours[3],
      hours_friday: source.business_registry_center_hours[4],
      note: source.business_registry_center_note
    }

    return unless attributes.compact.any?

    type = Court::Office::Type.find_by(value: 'Informačné stredisko obchodného registra')
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)
    court.business_registry_center = office
  end
end
