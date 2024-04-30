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

ActiveRecord::Schema[7.1].define(version: 2024_04_06_084627) do
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

  create_table "obcan_justice_sk_civil_hearings", force: :cascade do |t|
    t.string "guid", null: false
    t.string "uri", null: false
    t.jsonb "data", default: "{}", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checksum"], name: "index_obcan_justice_sk_civil_hearings_on_checksum", unique: true
    t.index ["data"], name: "index_obcan_justice_sk_civil_hearings_on_data", using: :gin
    t.index ["guid"], name: "index_obcan_justice_sk_civil_hearings_on_guid", unique: true
    t.index ["uri"], name: "index_obcan_justice_sk_civil_hearings_on_uri", unique: true
  end

  create_table "obcan_justice_sk_courts", force: :cascade do |t|
    t.string "guid", null: false
    t.string "uri", null: false
    t.jsonb "data", default: "{}", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checksum"], name: "index_obcan_justice_sk_courts_on_checksum", unique: true
    t.index ["data"], name: "index_obcan_justice_sk_courts_on_data", using: :gin
    t.index ["guid"], name: "index_obcan_justice_sk_courts_on_guid", unique: true
    t.index ["uri"], name: "index_obcan_justice_sk_courts_on_uri", unique: true
  end

  create_table "obcan_justice_sk_criminal_hearings", force: :cascade do |t|
    t.string "guid", null: false
    t.string "uri", null: false
    t.jsonb "data", default: "{}", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checksum"], name: "index_obcan_justice_sk_criminal_hearings_on_checksum", unique: true
    t.index ["data"], name: "index_obcan_justice_sk_criminal_hearings_on_data", using: :gin
    t.index ["guid"], name: "index_obcan_justice_sk_criminal_hearings_on_guid", unique: true
    t.index ["uri"], name: "index_obcan_justice_sk_criminal_hearings_on_uri", unique: true
  end

  create_table "obcan_justice_sk_decrees", force: :cascade do |t|
    t.string "guid", null: false
    t.string "uri", null: false
    t.jsonb "data", default: "{}", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checksum"], name: "index_obcan_justice_sk_decrees_on_checksum", unique: true
    t.index ["data"], name: "index_obcan_justice_sk_decrees_on_data", using: :gin
    t.index ["guid"], name: "index_obcan_justice_sk_decrees_on_guid", unique: true
    t.index ["uri"], name: "index_obcan_justice_sk_decrees_on_uri", unique: true
  end

  create_table "obcan_justice_sk_judges", force: :cascade do |t|
    t.string "guid", null: false
    t.string "uri", null: false
    t.jsonb "data", default: "{}", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["checksum"], name: "index_obcan_justice_sk_judges_on_checksum", unique: true
    t.index ["data"], name: "index_obcan_justice_sk_judges_on_data", using: :gin
    t.index ["guid"], name: "index_obcan_justice_sk_judges_on_guid", unique: true
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
