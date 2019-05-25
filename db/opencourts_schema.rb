# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170305154502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "pg_trgm"
  enable_extension "unaccent"

  create_table "accusations", id: :serial, force: :cascade do |t|
    t.integer "defendant_id", null: false
    t.string "value", limit: 510, null: false
    t.string "value_unprocessed", limit: 510, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["defendant_id", "value"], name: "index_accusations_on_defendant_id_and_value", unique: true
  end

  create_table "court_expenses", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "court_id", null: false
    t.integer "year", null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_court_expenses_on_court_id"
    t.index ["source_id"], name: "index_court_expenses_on_source_id"
    t.index ["uri"], name: "index_court_expenses_on_uri"
    t.index ["year"], name: "index_court_expenses_on_year"
  end

  create_table "court_jurisdictions", id: :serial, force: :cascade do |t|
    t.integer "court_proceeding_type_id", null: false
    t.integer "municipality_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_proceeding_type_id"], name: "index_court_jurisdictions_on_court_proceeding_type_id"
    t.index ["municipality_id"], name: "index_court_jurisdictions_on_municipality_id"
  end

  create_table "court_office_types", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_court_office_types_on_value", unique: true
  end

  create_table "court_offices", id: :serial, force: :cascade do |t|
    t.integer "court_id", null: false
    t.integer "court_office_type_id", null: false
    t.string "email", limit: 255
    t.string "phone", limit: 255
    t.string "hours_monday", limit: 255
    t.string "hours_tuesday", limit: 255
    t.string "hours_wednesday", limit: 255
    t.string "hours_thursday", limit: 255
    t.string "hours_friday", limit: 255
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_court_offices_on_court_id"
  end

  create_table "court_proceeding_types", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_court_proceeding_types_on_value", unique: true
  end

  create_table "court_statistical_summaries", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "court_id", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id", "year"], name: "index_court_statistical_summaries_on_court_and_year", unique: true
    t.index ["court_id"], name: "index_court_statistical_summaries_on_court_id"
    t.index ["source_id"], name: "index_court_statistical_summaries_on_source_id"
    t.index ["uri"], name: "index_court_statistical_summaries_on_uri"
    t.index ["year"], name: "index_court_statistical_summaries_on_year"
  end

  create_table "court_types", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_court_types_on_value", unique: true
  end

  create_table "courts", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "court_type_id", null: false
    t.integer "court_jurisdiction_id"
    t.integer "municipality_id", null: false
    t.string "name", limit: 255, null: false
    t.string "street", limit: 255, null: false
    t.string "phone", limit: 255
    t.string "fax", limit: 255
    t.string "media_person", limit: 255
    t.string "media_person_unprocessed", limit: 255
    t.string "media_phone", limit: 255
    t.integer "information_center_id"
    t.integer "registry_center_id"
    t.integer "business_registry_center_id"
    t.decimal "latitude", precision: 12, scale: 8
    t.decimal "longitude", precision: 12, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "acronym", limit: 255
    t.index ["acronym"], name: "index_courts_on_acronym"
    t.index ["court_jurisdiction_id"], name: "index_courts_on_court_jurisdiction_id"
    t.index ["court_type_id"], name: "index_courts_on_court_type_id"
    t.index ["municipality_id"], name: "index_courts_on_municipality_id"
    t.index ["name"], name: "index_courts_on_name", unique: true
    t.index ["source_id"], name: "index_courts_on_source_id"
    t.index ["uri"], name: "index_courts_on_uri", unique: true
  end

  create_table "decree_forms", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.string "code", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_decree_forms_on_value", unique: true
  end

  create_table "decree_naturalizations", id: :serial, force: :cascade do |t|
    t.integer "decree_id", null: false
    t.integer "decree_nature_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decree_id", "decree_nature_id"], name: "index_decree_naturalizations_on_decree_id_and_decree_nature_id", unique: true
    t.index ["decree_nature_id", "decree_id"], name: "index_decree_naturalizations_on_decree_nature_id_and_decree_id", unique: true
  end

  create_table "decree_natures", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_decree_natures_on_value", unique: true
  end

  create_table "decree_pages", id: :serial, force: :cascade do |t|
    t.integer "decree_id", null: false
    t.integer "number", null: false
    t.text "text", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decree_id", "number"], name: "index_decree_pages_on_decree_id_and_number", unique: true
  end

  create_table "decrees", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "proceeding_id"
    t.integer "court_id"
    t.integer "decree_form_id"
    t.string "case_number", limit: 255
    t.string "file_number", limit: 255
    t.date "date"
    t.string "ecli", limit: 255
    t.text "summary"
    t.integer "legislation_area_id"
    t.integer "legislation_subarea_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "pdf_uri", limit: 2048
    t.index ["case_number"], name: "index_decrees_on_case_number"
    t.index ["court_id"], name: "index_decrees_on_court_id"
    t.index ["decree_form_id"], name: "index_decrees_on_decree_form_id"
    t.index ["ecli"], name: "index_decrees_on_ecli"
    t.index ["file_number"], name: "index_decrees_on_file_number"
    t.index ["proceeding_id"], name: "index_decrees_on_proceeding_id"
    t.index ["source_id"], name: "index_decrees_on_source_id"
    t.index ["updated_at", "id"], name: "index_decrees_on_updated_at_and_id"
    t.index ["updated_at"], name: "index_decrees_on_updated_at"
    t.index ["uri"], name: "index_decrees_on_uri", unique: true
  end

  create_table "defendants", id: :serial, force: :cascade do |t|
    t.integer "hearing_id", null: false
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hearing_id", "name"], name: "index_defendants_on_hearing_id_and_name", unique: true
    t.index ["name"], name: "index_defendants_on_name"
    t.index ["name_unprocessed"], name: "index_defendants_on_name_unprocessed"
  end

  create_table "employments", id: :serial, force: :cascade do |t|
    t.integer "court_id", null: false
    t.integer "judge_id", null: false
    t.integer "judge_position_id"
    t.boolean "active"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_employments_on_active"
    t.index ["court_id", "judge_id"], name: "index_employments_on_court_id_and_judge_id"
    t.index ["judge_id", "court_id"], name: "index_employments_on_judge_id_and_court_id"
  end

  create_table "hearing_forms", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_hearing_forms_on_value", unique: true
  end

  create_table "hearing_sections", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_hearing_sections_on_value", unique: true
  end

  create_table "hearing_subjects", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_hearing_subjects_on_value", unique: true
  end

  create_table "hearing_types", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_hearing_types_on_value", unique: true
  end

  create_table "hearings", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "proceeding_id"
    t.integer "court_id"
    t.integer "hearing_type_id", null: false
    t.integer "hearing_section_id"
    t.integer "hearing_subject_id"
    t.integer "hearing_form_id"
    t.string "case_number", limit: 255
    t.string "file_number", limit: 255
    t.datetime "date"
    t.string "room", limit: 255
    t.string "special_type", limit: 255
    t.datetime "commencement_date"
    t.boolean "selfjudge"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "anonymized", default: false
    t.index ["case_number"], name: "index_hearings_on_case_number"
    t.index ["court_id"], name: "index_hearings_on_court_id"
    t.index ["file_number"], name: "index_hearings_on_file_number"
    t.index ["proceeding_id"], name: "index_hearings_on_proceeding_id"
    t.index ["source_id"], name: "index_hearings_on_source_id"
    t.index ["uri"], name: "index_hearings_on_uri", unique: true
  end

  create_table "judge_designation_types", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_designation_types_on_value", unique: true
  end

  create_table "judge_designations", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "judge_id", null: false
    t.integer "judge_designation_type_id"
    t.date "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_judge_designations_on_date"
    t.index ["judge_designation_type_id"], name: "index_judge_designations_on_judge_designation_type_id"
    t.index ["judge_id"], name: "index_judge_designations_on_judge_id"
    t.index ["source_id"], name: "index_judge_designations_on_source_id"
    t.index ["uri"], name: "index_judge_designations_on_uri"
  end

  create_table "judge_incomes", id: :serial, force: :cascade do |t|
    t.integer "judge_property_declaration_id", null: false
    t.string "description", limit: 255, null: false
    t.decimal "value", precision: 12, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_judge_incomes_on_description"
    t.index ["judge_property_declaration_id", "description"], name: "index_judge_incomes_on_unique_values", unique: true
  end

  create_table "judge_positions", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_positions_on_value", unique: true
  end

  create_table "judge_proclaims", id: :serial, force: :cascade do |t|
    t.integer "judge_property_declaration_id", null: false
    t.integer "judge_statement_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_property_declaration_id", "judge_statement_id"], name: "index_judge_proclaims_on_unique_values", unique: true
    t.index ["judge_statement_id", "judge_property_declaration_id"], name: "index_judge_proclaims_on_unique_values_reversed", unique: true
  end

  create_table "judge_properties", id: :serial, force: :cascade do |t|
    t.integer "judge_property_list_id", null: false
    t.integer "judge_property_acquisition_reason_id"
    t.integer "judge_property_ownership_form_id"
    t.integer "judge_property_change_id"
    t.string "description", limit: 255
    t.string "acquisition_date", limit: 255
    t.bigint "cost"
    t.string "share_size", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_property_list_id"], name: "index_judge_properties_on_judge_property_list_id"
  end

  create_table "judge_property_acquisition_reasons", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_property_acquisition_reasons_on_value", unique: true
  end

  create_table "judge_property_categories", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_property_categories_on_value", unique: true
  end

  create_table "judge_property_changes", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_property_changes_on_value", unique: true
  end

  create_table "judge_property_declarations", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 255
    t.integer "source_id", null: false
    t.integer "court_id", null: false
    t.integer "judge_id", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["court_id"], name: "index_judge_property_declarations_on_court_id"
    t.index ["judge_id", "year"], name: "index_judge_property_declarations_on_judge_id_and_year", unique: true
    t.index ["source_id"], name: "index_judge_property_declarations_on_source_id"
    t.index ["uri"], name: "index_judge_property_declarations_on_uri", unique: true
    t.index ["year", "judge_id"], name: "index_judge_property_declarations_on_year_and_judge_id", unique: true
  end

  create_table "judge_property_lists", id: :serial, force: :cascade do |t|
    t.integer "judge_property_declaration_id", null: false
    t.integer "judge_property_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_property_category_id", "judge_property_declaration_id"], name: "index_judge_property_lists_on_unique_values_reversed", unique: true
    t.index ["judge_property_declaration_id", "judge_property_category_id"], name: "index_judge_property_lists_on_unique_values", unique: true
  end

  create_table "judge_property_ownership_forms", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_property_ownership_forms_on_value", unique: true
  end

  create_table "judge_related_people", id: :serial, force: :cascade do |t|
    t.integer "judge_property_declaration_id", null: false
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.string "institution", limit: 255
    t.string "function", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["function"], name: "index_judge_related_people_on_function"
    t.index ["institution"], name: "index_judge_related_people_on_institution"
    t.index ["judge_property_declaration_id", "name"], name: "index_judge_related_people_on_unique_values", unique: true
    t.index ["name"], name: "index_judge_related_people_on_name"
  end

  create_table "judge_senate_inclusions", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_senate_inclusions_on_value", unique: true
  end

  create_table "judge_statements", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_judge_statements_on_value", unique: true
  end

  create_table "judge_statistical_summaries", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "court_id", null: false
    t.integer "judge_id", null: false
    t.integer "judge_senate_inclusion_id"
    t.string "author", limit: 255
    t.integer "year", null: false
    t.date "date"
    t.integer "days_worked"
    t.integer "days_heard"
    t.integer "days_used"
    t.integer "released_constitutional_decrees"
    t.integer "delayed_constitutional_decrees"
    t.text "idea_reduction_reasons"
    t.text "educational_activities"
    t.text "substantiation_notes"
    t.text "court_chair_actions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author"], name: "index_judge_statistical_summaries_on_author"
    t.index ["court_id", "judge_id", "year"], name: "index_judge_statistical_summaries_on_court_and_judge_and_year", unique: true
    t.index ["court_id"], name: "index_judge_statistical_summaries_on_court_id"
    t.index ["date"], name: "index_judge_statistical_summaries_on_date"
    t.index ["judge_id"], name: "index_judge_statistical_summaries_on_judge_id"
    t.index ["source_id"], name: "index_judge_statistical_summaries_on_source_id"
    t.index ["uri"], name: "index_judge_statistical_summaries_on_uri"
    t.index ["year"], name: "index_judge_statistical_summaries_on_year"
  end

  create_table "judgements", id: :serial, force: :cascade do |t|
    t.integer "decree_id", null: false
    t.integer "judge_id"
    t.decimal "judge_name_similarity", precision: 3, scale: 2, null: false
    t.string "judge_name_unprocessed", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decree_id", "judge_id"], name: "index_judgements_on_decree_id_and_judge_id", unique: true
    t.index ["judge_id", "decree_id"], name: "index_judgements_on_judge_id_and_decree_id", unique: true
    t.index ["judge_name_unprocessed"], name: "index_judgements_on_judge_name_unprocessed"
  end

  create_table "judges", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.string "prefix", limit: 255
    t.string "first", limit: 255, null: false
    t.string "middle", limit: 255
    t.string "last", limit: 255, null: false
    t.string "suffix", limit: 255
    t.string "addition", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["first", "middle", "last"], name: "index_judges_on_first_and_middle_and_last"
    t.index ["last", "middle", "first"], name: "index_judges_on_last_and_middle_and_first"
    t.index ["name"], name: "index_judges_on_name", unique: true
    t.index ["name_unprocessed"], name: "index_judges_on_name_unprocessed", unique: true
    t.index ["source_id"], name: "index_judges_on_source_id"
    t.index ["uri"], name: "index_judges_on_uri"
  end

  create_table "judgings", id: :serial, force: :cascade do |t|
    t.integer "hearing_id", null: false
    t.integer "judge_id"
    t.decimal "judge_name_similarity", precision: 3, scale: 2, null: false
    t.string "judge_name_unprocessed", limit: 255, null: false
    t.boolean "judge_chair", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hearing_id", "judge_id"], name: "index_judgings_on_hearing_id_and_judge_id", unique: true
    t.index ["judge_id", "hearing_id"], name: "index_judgings_on_judge_id_and_hearing_id", unique: true
    t.index ["judge_name_unprocessed"], name: "index_judgings_on_judge_name_unprocessed"
  end

  create_table "legislation_areas", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_legislation_areas_on_value"
  end

  create_table "legislation_subareas", id: :serial, force: :cascade do |t|
    t.integer "legislation_area_id", null: false
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["legislation_area_id"], name: "index_legislation_subareas_on_legislation_area_id"
    t.index ["value"], name: "index_legislation_subareas_on_value"
  end

  create_table "legislation_usages", id: :serial, force: :cascade do |t|
    t.integer "legislation_id", null: false
    t.integer "decree_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["decree_id", "legislation_id"], name: "index_legislation_usages_on_decree_id_and_legislation_id", unique: true
    t.index ["legislation_id", "decree_id"], name: "index_legislation_usages_on_legislation_id_and_decree_id", unique: true
  end

  create_table "legislations", id: :serial, force: :cascade do |t|
    t.string "value", limit: 510, null: false
    t.string "value_unprocessed", limit: 510, null: false
    t.string "type", limit: 255
    t.integer "number"
    t.integer "year"
    t.string "name", limit: 510
    t.string "section", limit: 255
    t.string "paragraph", limit: 255
    t.string "letter", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_legislations_on_value", unique: true
  end

  create_table "municipalities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.string "zipcode", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_municipalities_on_name", unique: true
    t.index ["zipcode"], name: "index_municipalities_on_zipcode"
  end

  create_table "opponents", id: :serial, force: :cascade do |t|
    t.integer "hearing_id", null: false
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hearing_id", "name"], name: "index_opponents_on_hearing_id_and_name", unique: true
    t.index ["name"], name: "index_opponents_on_name"
    t.index ["name_unprocessed"], name: "index_opponents_on_name_unprocessed"
  end

  create_table "paragraph_explanations", id: :serial, force: :cascade do |t|
    t.integer "paragraph_id", null: false
    t.integer "explainable_id", null: false
    t.string "explainable_type", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["explainable_id", "explainable_type", "paragraph_id"], name: "index_paragraph_explainations_on_unique_values_reversed", unique: true
    t.index ["paragraph_id", "explainable_id", "explainable_type"], name: "index_paragraph_explainations_on_unique_values", unique: true
  end

  create_table "paragraphs", id: :serial, force: :cascade do |t|
    t.integer "legislation", null: false
    t.string "number", limit: 255, null: false
    t.string "description", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["legislation", "number"], name: "index_paragraphs_on_legislation_and_number", unique: true
  end

  create_table "periods", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, null: false
    t.integer "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_periods_on_name", unique: true
  end

  create_table "proceedings", id: :serial, force: :cascade do |t|
    t.string "file_number", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_number"], name: "index_proceedings_on_file_number", unique: true
  end

  create_table "proposers", id: :serial, force: :cascade do |t|
    t.integer "hearing_id", null: false
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hearing_id", "name"], name: "index_proposers_on_hearing_id_and_name", unique: true
    t.index ["name"], name: "index_proposers_on_name"
    t.index ["name_unprocessed"], name: "index_proposers_on_name_unprocessed"
  end

  create_table "queries", id: :serial, force: :cascade do |t|
    t.string "model", limit: 255, null: false
    t.string "digest", limit: 255, null: false
    t.text "value", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["digest", "model"], name: "index_queries_on_digest_and_model", unique: true
    t.index ["model", "digest"], name: "index_queries_on_model_and_digest", unique: true
  end

  create_table "selection_procedure_candidates", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 255
    t.integer "selection_procedure_id", null: false
    t.integer "judge_id"
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.text "accomplished_expectations"
    t.string "oral_score", limit: 255
    t.string "oral_result", limit: 255
    t.string "written_score", limit: 255
    t.string "written_result", limit: 255
    t.string "score", limit: 255
    t.string "rank", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "application_url", limit: 2048
    t.string "curriculum_url", limit: 2048
    t.string "declaration_url", limit: 2048
    t.string "motivation_letter_url", limit: 2048
    t.index ["judge_id"], name: "index_selection_procedure_candidates_on_judge_id"
    t.index ["name"], name: "index_selection_procedure_candidates_on_name"
    t.index ["name_unprocessed"], name: "index_selection_procedure_candidates_on_name_unprocessed"
    t.index ["selection_procedure_id"], name: "index_selection_procedure_candidates_on_selection_procedure_id"
  end

  create_table "selection_procedure_commissioners", id: :serial, force: :cascade do |t|
    t.integer "selection_procedure_id", null: false
    t.integer "judge_id"
    t.string "name", limit: 255, null: false
    t.string "name_unprocessed", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["judge_id"], name: "index_selection_procedure_commissioners_on_judge_id"
    t.index ["name"], name: "index_selection_procedure_commissioners_on_name"
    t.index ["name_unprocessed"], name: "index_selection_procedure_commissioners_on_name_unprocessed"
    t.index ["selection_procedure_id"], name: "index_commissioners_on_selection_procedure"
  end

  create_table "selection_procedures", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.integer "source_id", null: false
    t.integer "court_id"
    t.string "organization_name", limit: 255, null: false
    t.string "organization_name_unprocessed", limit: 255, null: false
    t.text "organization_description"
    t.date "date"
    t.text "description"
    t.string "place", limit: 255
    t.string "position", limit: 255, null: false
    t.string "state", limit: 255
    t.string "workplace", limit: 255
    t.datetime "closed_at", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "declaration_url", limit: 2048
    t.string "report_url", limit: 2048
    t.index ["closed_at"], name: "index_selection_procedures_on_closed_at"
    t.index ["court_id"], name: "index_selection_procedures_on_court_id"
    t.index ["date"], name: "index_selection_procedures_on_date"
    t.index ["organization_name"], name: "index_selection_procedures_on_organization_name"
    t.index ["organization_name_unprocessed"], name: "index_selection_procedures_on_organization_name_unprocessed"
    t.index ["source_id"], name: "index_selection_procedures_on_source_id"
    t.index ["uri"], name: "index_selection_procedures_on_uri"
  end

  create_table "sources", id: :serial, force: :cascade do |t|
    t.string "module", limit: 255, null: false
    t.string "name", limit: 255, null: false
    t.string "uri", limit: 2048, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["module"], name: "index_sources_on_module", unique: true
    t.index ["name"], name: "index_sources_on_name", unique: true
    t.index ["uri"], name: "index_sources_on_uri", unique: true
  end

  create_table "statistical_table_cells", id: :serial, force: :cascade do |t|
    t.integer "statistical_table_column_id", null: false
    t.integer "statistical_table_row_id", null: false
    t.string "value", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statistical_table_column_id", "statistical_table_row_id"], name: "index_statistical_table_cells_on_unique_values", unique: true
    t.index ["statistical_table_row_id", "statistical_table_column_id"], name: "index_statistical_table_cells_on_unique_values_reversed", unique: true
  end

  create_table "statistical_table_column_names", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_statistical_table_column_names_on_value", unique: true
  end

  create_table "statistical_table_columns", id: :serial, force: :cascade do |t|
    t.integer "statistical_table_id", null: false
    t.integer "statistical_table_column_name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statistical_table_id", "statistical_table_column_name_id"], name: "index_statistical_table_columns_on_unique_values", unique: true
  end

  create_table "statistical_table_names", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_statistical_table_names_on_value", unique: true
  end

  create_table "statistical_table_row_names", id: :serial, force: :cascade do |t|
    t.string "value", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_statistical_table_row_names_on_value", unique: true
  end

  create_table "statistical_table_rows", id: :serial, force: :cascade do |t|
    t.integer "statistical_table_id", null: false
    t.integer "statistical_table_row_name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statistical_table_id", "statistical_table_row_name_id"], name: "index_statistical_table_rows_on_unique_values", unique: true
  end

  create_table "statistical_tables", id: :serial, force: :cascade do |t|
    t.integer "statistical_summary_id", null: false
    t.string "statistical_summary_type", limit: 255, null: false
    t.integer "statistical_table_name_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["statistical_summary_id", "statistical_summary_type", "statistical_table_name_id"], name: "index_statistical_tables_on_summary_and_name", unique: true
    t.index ["statistical_table_name_id"], name: "index_statistical_tables_on_statistical_table_name_id"
  end

  create_table "subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "query_id", null: false
    t.integer "period_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["period_id"], name: "index_subscriptions_on_period_id"
    t.index ["query_id"], name: "index_subscriptions_on_query_id"
    t.index ["user_id", "query_id", "period_id"], name: "index_subscriptions_on_user_id_and_query_id_and_period_id", unique: true
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.datetime "confirmed_at"
    t.string "confirmation_token", limit: 255
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email", limit: 255
    t.datetime "remember_created_at"
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unconfirmed_email"], name: "index_users_on_unconfirmed_email", unique: true
  end

end
