class CourtReconciler
  attr_reader :mapper, :court

  def initialize(court, mapper:)
    @court = court
    @mapper = mapper
  end

  def reconcile!
    court.with_lock do
      reconcile_attributes
      reconcile_type
      reconcile_municipality
      reconcile_information_center
      reconcile_registry_center
      reconcile_business_registry_center

      court.save!
      court.touch
    end
  end

  def reconcile_attributes
    # TODO remove source, leave now for compatibility
    court.assign_attributes(
      uri: mapper.uri,
      source: Source.find_by!(module: mapper.source),
      source_class: mapper.source_class,
      source_class_id: mapper.source_class_id,
      name: mapper.name,
      street: mapper.street,
      phone: mapper.phone,
      fax: mapper.fax,
      media_person: mapper.media_person,
      media_phone: mapper.media_phone,
      data_protection_email: mapper.data_protection_email,
      latitude: mapper.latitude,
      longitude: mapper.longitude,
      acronym: mapper.acronym,
      other_contacts_json:
        mapper.respond_to?(:other_contacts) && mapper.other_contacts.present? ? JSON.dump(mapper.other_contacts) : nil
    )
  end

  def reconcile_type
    court.type = Court::Type.find_by!(value: mapper.type)
  end

  def reconcile_municipality
    municipality = Municipality.find_or_initialize_by(name: mapper.municipality)

    municipality.assign_attributes(zipcode: mapper.zipcode)

    court.municipality = municipality
  end

  def reconcile_information_center
    office =
      build_office(
        'Informačné centrum',
        email: mapper.information_center_email,
        phone: mapper.information_center_phone,
        hours_monday: mapper.information_center_hours[0],
        hours_tuesday: mapper.information_center_hours[1],
        hours_wednesday: mapper.information_center_hours[2],
        hours_thursday: mapper.information_center_hours[3],
        hours_friday: mapper.information_center_hours[4],
        note: mapper.information_center_note
      )

    court.information_center = office if office
  end

  def reconcile_registry_center
    office =
      build_office(
        'Podateľňa',
        email: mapper.registry_center_email,
        phone: mapper.registry_center_phone,
        hours_monday: mapper.registry_center_hours[0],
        hours_tuesday: mapper.registry_center_hours[1],
        hours_wednesday: mapper.registry_center_hours[2],
        hours_thursday: mapper.registry_center_hours[3],
        hours_friday: mapper.registry_center_hours[4],
        note: mapper.registry_center_note
      )

    court.registry_center = office if office
  end

  def reconcile_business_registry_center
    office =
      build_office(
        'Informačné stredisko obchodného registra',
        email: mapper.business_registry_center_email,
        phone: mapper.business_registry_center_phone,
        hours_monday: mapper.business_registry_center_hours[0],
        hours_tuesday: mapper.business_registry_center_hours[1],
        hours_wednesday: mapper.business_registry_center_hours[2],
        hours_thursday: mapper.business_registry_center_hours[3],
        hours_friday: mapper.business_registry_center_hours[4],
        note: mapper.business_registry_center_note
      )

    court.business_registry_center = office if office
  end

  private

  def build_office(name, attributes)
    return unless attributes.compact.any?

    type = Court::Office::Type.find_by!(value: name)
    office = Court::Office.find_or_initialize_by(court: court, type: type)

    office.assign_attributes(attributes)

    office
  end
end
