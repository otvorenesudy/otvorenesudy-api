class CreateJusticeGovSkJudges < ActiveRecord::Migration
  def change
    create_table :justice_gov_sk_judges do |t|
      t.string :uri, limit: 2048, null: false
      t.text :html, null: false

      t.string :meno
      t.string :sud
      t.string :sud_uri, limit: 2048
      t.boolean :aktivny
      t.text :poznamka
    end

    add_index :justice_gov_sk_judges, :uri, unique: true
  end
end
