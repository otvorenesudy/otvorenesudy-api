# frozen_string_literal: true

# The lookup rows otvorenesudy's seeds keep in the Open Courts database, which the reconcilers find by value: the
# source, the types of courts, court offices and hearings, and the decree forms the fixtures use.
module OpenCourtsLookups
  COURT_TYPES = %w[Krajský Mestský Najvyšší Okresný Správny Špecializovaný].freeze
  OFFICE_TYPES = ['Informačné centrum', 'Podateľňa', 'Informačné stredisko obchodného registra'].freeze
  HEARING_TYPES = ['Civilné', 'Trestné', 'Špecializovaného trestného súdu'].freeze

  def create_lookups
    create(:source, module: 'JusticeGovSk', name: 'Ministerstvo spravodlivosti Slovenskej republiky')
    COURT_TYPES.each { |value| create(:court_type, value:) }
    OFFICE_TYPES.each { |value| create(:court_office_type, value:) }
    HEARING_TYPES.each { |value| create(:hearing_type, value:) }
    create(:decree_form, value: 'Rozsudok', code: 'A')
  end
end

RSpec.configure do |config|
  config.include OpenCourtsLookups
end
