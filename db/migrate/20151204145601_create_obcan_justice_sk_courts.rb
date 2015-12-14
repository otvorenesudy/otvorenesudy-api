class CreateObcanJusticeSkCourts < ActiveRecord::Migration
  def change
    create_table :obcan_justice_sk_courts do |t|
      t.string :uri, limit: 2048, null: false
      t.text :html, null: false

      t.string :nazov
      t.string :adresa
      t.string :psc
      t.string :mesto
      t.string :predseda
      t.string :predseda_uri, limit: 2048
      t.string :podpredseda, array: true
      t.string :podpredseda_uri, array: true, limit: 2048
      t.string :telefon
      t.string :fax
      t.string :latitude
      t.string :longitude
      t.string :sud_foto_uri, limit: 2048

      t.string :kontaktna_osoba_pre_media
      t.string :telefon_pre_media
      t.string :email_pre_media
      t.string :internetova_stranka_pre_media

      t.string :informacne_centrum_telefonne_cislo
      t.string :informacne_centrum_email
      t.string :informacne_centrum_uradne_hodiny, array: true
      t.text :informacne_centrum_uradne_hodiny_poznamka

      t.string :podatelna_telefonne_cislo
      t.string :podatelna_email
      t.string :podatelna_uradne_hodiny, array: true
      t.text :podatelna_uradne_hodiny_poznamka

      t.string :obchodny_register_telefonne_cislo
      t.string :obchodny_register_email
      t.string :obchodny_register_uradne_hodiny, array: true
      t.text :obchodny_register_uradne_hodiny_poznamka

      t.timestamps
    end

    add_index :obcan_justice_sk_courts, :uri, unique: true
  end
end
