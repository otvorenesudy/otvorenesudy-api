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

ActiveRecord::Schema.define(version: 20151125160428) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: :cascade do |t|
    t.string   "value",      null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["value"], name: "index_api_keys_on_value", unique: true, using: :btree
  end

  create_table "invites", force: :cascade do |t|
    t.string   "email",      null: false
    t.string   "locale",     null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "locale"], name: "index_invites_on_email_and_locale", unique: true, using: :btree
  end

  create_table "justice_gov_sk_decrees", force: :cascade do |t|
    t.string "uri",                       limit: 2048, null: false
    t.text   "html",                                   null: false
    t.string "forma"
    t.string "sud"
    t.string "sudca"
    t.string "sud_uri",                   limit: 2048
    t.string "sudca_uri",                 limit: 2048
    t.string "datum_vydania_rozhodnutia"
    t.string "spisova_znacka"
    t.string "identifikacne_cislo_spisu"
    t.string "oblast_pravnej_upravy"
    t.string "povaha_rozhodnutia"
    t.string "ecli"
    t.string "predpisy",                                            array: true
    t.string "pdf_url"
    t.index ["uri"], name: "index_justice_gov_sk_decrees_on_uri", unique: true, using: :btree
  end

end
