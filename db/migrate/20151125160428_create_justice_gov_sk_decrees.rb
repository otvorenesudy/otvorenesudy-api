class CreateJusticeGovSkDecrees < ActiveRecord::Migration
  def change
    create_table :justice_gov_sk_decrees do |t|
      t.string :uri, null: false, limit: 2048
      t.text :html, null: false

      t.string :forma
      t.string :sud
      t.string :sudca
      t.string :sud_uri, limit: 2048
      t.string :sudca_uri, limit: 2048
      t.string :datum
      t.string :spisova_znacka
      t.string :identifikacne_cislo_spisu
      t.string :oblast_pravnej_upravy
      t.string :povaha
      t.string :ecli
      t.string :predpisy, array: true
      t.string :pdf_uri, limit: 2048

      t.timestamps
    end

    add_index :justice_gov_sk_decrees, :uri, unique: true
  end
end
