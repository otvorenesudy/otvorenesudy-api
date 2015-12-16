class CreateLegacyHearings < ActiveRecord::Migration
  def change
    create_table :legacy_hearings do |t|
      t.string :uri, null: false, limit: 2048
      t.json :source, null: false

      t.string :predmet
      t.string :sud
      t.string :sudca
      t.string :sud_uri, limit: 2048
      t.string :sudca_uri, limit: 2048
      t.string :datum
      t.string :cas
      t.string :usek
      t.string :spisova_znacka
      t.string :identifikacne_cislo_spisu
      t.string :forma_ukonu
      t.text :poznamka
      t.string :navrhovatelia, array: true
      t.string :odporcovia, array: true
      t.string :obzalovani, array: true
      t.string :miestnost

      t.timestamps
    end

    add_index :legacy_hearings, :uri, unique: true
  end
end
