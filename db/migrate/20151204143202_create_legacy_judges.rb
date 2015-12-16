class CreateLegacyJudges < ActiveRecord::Migration
  def change
    create_table :legacy_judges do |t|
      t.string :uri, limit: 2048, null: false
      t.json :source, null: false

      t.string :meno
      t.string :sud
      t.string :sud_uri, limit: 2048
      t.string :docasny_sud
      t.string :docasny_sud_uri, limit: 2048
      t.boolean :aktivny
      t.text :poznamka

      t.timestamps
    end

    add_index :legacy_judges, :uri, unique: true
  end
end
