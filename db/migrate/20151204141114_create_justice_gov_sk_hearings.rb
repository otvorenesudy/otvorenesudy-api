class CreateJusticeGovSkHearings < ActiveRecord::Migration
  def change
    create_table :justice_gov_sk_hearings do |t|
      t.string :uri, null: false, limit: 2048
      t.text :html, null: false

      t.string :predmet
      t.string :sud
      t.string :sudca
      t.string :sud_uri, limit: 2048
      t.string :sudca_uri, limit: 2048
      t.string :datum_pojednavania
      t.string :cas_pojednavania
      t.string :usek
      t.string :spisova_znacka
      t.string :identifikacne_cislo_spisu
      t.string :forma_ukonu
      t.string :poznamka
      t.string :navrhovatelia, array: true
      t.string :odporcovia, array: true
      t.string :obzalovani, array: true
      t.string :miestnost
    end

    add_index :justice_gov_sk_hearings, :uri, unique: true
  end
end
