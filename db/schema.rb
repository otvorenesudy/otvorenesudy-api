# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_01_29_212609) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", id: :serial, force: :cascade do |t|
    t.string "value", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["value"], name: "index_api_keys_on_value", unique: true
  end

  create_table "info_sud_courts", id: :serial, force: :cascade do |t|
    t.string "guid", null: false
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["guid"], name: "index_info_sud_courts_on_guid", unique: true
  end

  create_table "info_sud_decrees", id: :serial, force: :cascade do |t|
    t.string "guid", null: false
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["guid"], name: "index_info_sud_decrees_on_guid", unique: true
  end

  create_table "info_sud_hearings", id: :serial, force: :cascade do |t|
    t.string "guid", null: false
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["guid"], name: "index_info_sud_hearings_on_guid", unique: true
  end

  create_table "info_sud_judges", id: :serial, force: :cascade do |t|
    t.string "guid", null: false
    t.jsonb "data", default: "{}", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["guid"], name: "index_info_sud_judges_on_guid", unique: true
  end

  create_table "invites", id: :serial, force: :cascade do |t|
    t.string "email", null: false
    t.string "locale", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["email", "locale"], name: "index_invites_on_email_and_locale", unique: true
  end

  create_table "justice_gov_sk_pages", force: :cascade do |t|
    t.string "model", default: "0", null: false
    t.string "integer", default: "0", null: false
    t.string "uri", null: false
    t.jsonb "data", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uri"], name: "index_justice_gov_sk_pages_on_uri", unique: true
  end

  create_table "obcan_justice_sk_courts", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.text "html", null: false
    t.string "nazov"
    t.string "adresa"
    t.string "psc"
    t.string "mesto"
    t.string "predseda"
    t.string "predseda_uri", limit: 2048
    t.string "podpredseda", array: true
    t.string "podpredseda_uri", limit: 2048, array: true
    t.string "telefon"
    t.string "fax"
    t.string "latitude"
    t.string "longitude"
    t.string "sud_foto_uri", limit: 2048
    t.string "kontaktna_osoba_pre_media"
    t.string "telefon_pre_media"
    t.string "email_pre_media"
    t.string "internetova_stranka_pre_media"
    t.string "informacne_centrum_telefonne_cislo"
    t.string "informacne_centrum_email"
    t.string "informacne_centrum_uradne_hodiny", array: true
    t.text "informacne_centrum_uradne_hodiny_poznamka"
    t.string "podatelna_telefonne_cislo"
    t.string "podatelna_email"
    t.string "podatelna_uradne_hodiny", array: true
    t.text "podatelna_uradne_hodiny_poznamka"
    t.string "obchodny_register_telefonne_cislo"
    t.string "obchodny_register_email"
    t.string "obchodny_register_uradne_hodiny", array: true
    t.text "obchodny_register_uradne_hodiny_poznamka"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uri"], name: "index_obcan_justice_sk_courts_on_uri", unique: true
  end

  create_table "obcan_justice_sk_decrees", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.text "html", null: false
    t.string "forma"
    t.string "sud"
    t.string "sudca"
    t.string "sud_uri", limit: 2048
    t.string "sudca_uri", limit: 2048
    t.string "datum"
    t.string "spisova_znacka"
    t.string "identifikacne_cislo_spisu"
    t.string "oblast_pravnej_upravy"
    t.string "povaha"
    t.string "ecli"
    t.string "predpisy", array: true
    t.string "pdf_uri", limit: 2048
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uri"], name: "index_obcan_justice_sk_decrees_on_uri", unique: true
  end

  create_table "obcan_justice_sk_hearings", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.text "html", null: false
    t.string "predmet"
    t.string "sud"
    t.string "sudca"
    t.string "sud_uri", limit: 2048
    t.string "sudca_uri", limit: 2048
    t.string "datum"
    t.string "cas"
    t.string "usek"
    t.string "spisova_znacka"
    t.string "identifikacne_cislo_spisu"
    t.string "forma_ukonu"
    t.text "poznamka"
    t.string "navrhovatelia", array: true
    t.string "odporcovia", array: true
    t.string "obzalovani", array: true
    t.string "miestnost"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uri"], name: "index_obcan_justice_sk_hearings_on_uri", unique: true
  end

  create_table "obcan_justice_sk_judges", id: :serial, force: :cascade do |t|
    t.string "uri", limit: 2048, null: false
    t.text "html", null: false
    t.string "meno"
    t.string "sud"
    t.string "sud_uri", limit: 2048
    t.string "docasny_sud"
    t.string "docasny_sud_uri", limit: 2048
    t.boolean "aktivny"
    t.text "poznamka"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["uri"], name: "index_obcan_justice_sk_judges_on_uri", unique: true
  end

  create_table "public_prosecutor_refinements", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.string "ip_address", null: false
    t.string "prosecutor", null: false
    t.string "office", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["ip_address"], name: "index_public_prosecutor_refinements_on_ip_address"
  end

end
