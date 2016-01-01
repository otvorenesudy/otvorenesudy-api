class CourtReconciler
  attr_reader :mapper, :court

  def initialize(mapper, court)
    @mapper = mapper
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
      uri: mapper.uri,
      source: mapper.source,
      name: mapper.name,
      street: mapper.street,
      phone: mapper.phone,
      fax: mapper.fax,
      media_person: mapper.media_person,
      media_phone: mapper.media_phone,
      latitude: mapper.latitude,
      longitude: mapper.longitude
    )
  end

  def reconcile_type
    court.type = Court::Type.find_by(value: mapper.type)
  end

  def reconcile_municipality
    court.municipality = Municipality.find_or_initialize_by(name: mapper.municipality, zipcode: mapper.zipcode)
  end

  def reconcile_information_center
    attributes = {
      email: mapper.information_center_email,
      phone: mapper.information_center_phone,
      hours_monday: mapper.information_center_hours[0],
      hours_tuesday: mapper.information_center_hours[1],
      hours_wednesday: mapper.information_center_hours[2],
      hours_thursday: mapper.information_center_hours[3],
      hours_friday: mapper.information_center_hours[4],
      note: mapper.information_center_note
    }

    return unless attributes.compact.any?

    type = Court::Office::Type.find_by(value: 'Informačné centrum')
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)
    court.information_center = office
  end

  def reconcile_registry_center
    attributes = {
      email: mapper.registry_center_email,
      phone: mapper.registry_center_phone,
      hours_monday: mapper.registry_center_hours[0],
      hours_tuesday: mapper.registry_center_hours[1],
      hours_wednesday: mapper.registry_center_hours[2],
      hours_thursday: mapper.registry_center_hours[3],
      hours_friday: mapper.registry_center_hours[4],
      note: mapper.registry_center_note
    }

    return unless attributes.compact.any?

    type = Court::Office::Type.find_by(value: 'Podateľna')
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)
    court.registry_center = office
  end

  def reconcile_business_registry_center
    attributes = {
      email: mapper.business_registry_center_email,
      phone: mapper.business_registry_center_phone,
      hours_monday: mapper.business_registry_center_hours[0],
      hours_tuesday: mapper.business_registry_center_hours[1],
      hours_wednesday: mapper.business_registry_center_hours[2],
      hours_thursday: mapper.business_registry_center_hours[3],
      hours_friday: mapper.business_registry_center_hours[4],
      note: mapper.business_registry_center_note
    }

    return unless attributes.compact.any?

    type = Court::Office::Type.find_by(value: 'Informačné stredisko obchodného registra')
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)
    court.business_registry_center = office
  end
end
