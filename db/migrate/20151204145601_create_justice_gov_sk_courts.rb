class CreateJusticeGovSkCourts < ActiveRecord::Migration
  def change
    create_table :justice_gov_sk_courts do |t|
      t.string :uri, limit: 2048, null: false
      t.text :html, null: false

      t.string :nazov
      t.string :adresa
      t.string :psc
      t.string :mesto
      t.string :predseda
      t.string :podpredseda
      t.string :telefon
      t.string :fax
      t.string :lattiude
      t.string :longitude
      t.string :image, limit: 2048

      t.string :kontaktna_osoba_pre_media
      t.string :telefon_pre_media
      t.string :email_pre_media
      t.string :internetova_stranka_pre_media

      t.string :informacne_centrum_telefonne_cislo
      t.string :informacne_centrum_email
      t.string :informacne_centrum_uradne_hodiny, array: true

      t.string :podatelna_telefonne_cislo
      t.string :podatelna_email
      t.string :podatelna_uradne_hodiny, array: true
    end

    add_index :justice_gov_sk_courts, :uri, unique: true
  end
end
