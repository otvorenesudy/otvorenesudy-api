# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20151220191833) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_api_keys_on_value", unique: true, using: :btree
  end

  create_table "info_sud_courts", force: :cascade do |t|
    t.string   "guid",       null: false
    t.json     "data",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_info_sud_courts_on_guid", unique: true, using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.string   "email",      null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "locale"], name: "index_invites_on_email_and_locale", unique: true, using: :btree
  end

  create_table "obcan_justice_sk_courts", force: :cascade do |t|
    t.string   "uri",                                       limit: 2048, null: false
    t.text     "html",                                                   null: false
    t.string   "nazov"
    t.string   "adresa"
    t.string   "psc"
    t.string   "mesto"
    t.string   "predseda"
    t.string   "predseda_uri",                              limit: 2048
    t.string   "podpredseda",                                                         array: true
    t.string   "podpredseda_uri",                           limit: 2048,              array: true
    t.string   "telefon"
    t.string   "fax"
    t.string   "latitude"
    t.string   "longitude"
    t.string   "sud_foto_uri",                              limit: 2048
    t.string   "kontaktna_osoba_pre_media"
    t.string   "telefon_pre_media"
    t.string   "email_pre_media"
    t.string   "internetova_stranka_pre_media"
    t.string   "informacne_centrum_telefonne_cislo"
    t.string   "informacne_centrum_email"
    t.string   "informacne_centrum_uradne_hodiny",                                    array: true
    t.text     "informacne_centrum_uradne_hodiny_poznamka"
    t.string   "podatelna_telefonne_cislo"
    t.string   "podatelna_email"
    t.string   "podatelna_uradne_hodiny",                                             array: true
    t.text     "podatelna_uradne_hodiny_poznamka"
    t.string   "obchodny_register_telefonne_cislo"
    t.string   "obchodny_register_email"
    t.string   "obchodny_register_uradne_hodiny",                                     array: true
    t.text     "obchodny_register_uradne_hodiny_poznamka"
    t.datetime "created_at",                                             null: false
    t.datetime "updated_at",                                             null: false
    t.index ["uri"], name: "index_obcan_justice_sk_courts_on_uri", unique: true, using: :btree
  end

  create_table "obcan_justice_sk_decrees", force: :cascade do |t|
    t.string   "uri",                       limit: 2048, null: false
    t.text     "html",                                   null: false
    t.string   "forma"
    t.string   "sud"
    t.string   "sudca"
    t.string   "sud_uri",                   limit: 2048
    t.string   "sudca_uri",                 limit: 2048
    t.string   "datum"
    t.string   "spisova_znacka"
    t.string   "identifikacne_cislo_spisu"
    t.string   "oblast_pravnej_upravy"
    t.string   "povaha"
    t.string   "ecli"
    t.string   "predpisy",                                            array: true
    t.string   "pdf_uri",                   limit: 2048
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["uri"], name: "index_obcan_justice_sk_decrees_on_uri", unique: true, using: :btree
  end

  create_table "obcan_justice_sk_hearings", force: :cascade do |t|
    t.string   "uri",                       limit: 2048, null: false
    t.text     "html",                                   null: false
    t.string   "predmet"
    t.string   "sud"
    t.string   "sudca"
    t.string   "sud_uri",                   limit: 2048
    t.string   "sudca_uri",                 limit: 2048
    t.string   "datum"
    t.string   "cas"
    t.string   "usek"
    t.string   "spisova_znacka"
    t.string   "identifikacne_cislo_spisu"
    t.string   "forma_ukonu"
    t.text     "poznamka"
    t.string   "navrhovatelia",                                       array: true
    t.string   "odporcovia",                                          array: true
    t.string   "obzalovani",                                          array: true
    t.string   "miestnost"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.index ["uri"], name: "index_obcan_justice_sk_hearings_on_uri", unique: true, using: :btree
  end

  create_table "obcan_justice_sk_judges", force: :cascade do |t|
    t.string   "uri",             limit: 2048, null: false
    t.text     "html",                         null: false
    t.string   "meno"
    t.string   "sud"
    t.string   "sud_uri",         limit: 2048
    t.string   "docasny_sud"
    t.string   "docasny_sud_uri", limit: 2048
    t.boolean  "aktivny"
    t.text     "poznamka"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["uri"], name: "index_obcan_justice_sk_judges_on_uri", unique: true, using: :btree
  end

end
