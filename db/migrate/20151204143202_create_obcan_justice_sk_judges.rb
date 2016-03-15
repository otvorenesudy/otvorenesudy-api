class CreateObcanJusticeSkJudges < ActiveRecord::Migration[5.0]
  def change
    create_table :obcan_justice_sk_judges do |t|
      t.string :uri, limit: 2048, null: false
      t.text :html, null: false

      t.string :meno
      t.string :sud
      t.string :sud_uri, limit: 2048
      t.string :docasny_sud
      t.string :docasny_sud_uri, limit: 2048
      t.boolean :aktivny
      t.text :poznamka

      t.timestamps
    end

    add_index :obcan_justice_sk_judges, :uri, unique: true
  end
end
