class CreateJusticeGovSkPages < ActiveRecord::Migration[5.1]
  def change
    create_table :justice_gov_sk_pages do |t|
      t.string :model, :integer, default: 0, null: false
      t.string :uri, null: false
      t.jsonb :data, null: false
      
      t.timestamps null: false
    end

    add_index :justice_gov_sk_pages, :uri, unique: true
  end
end
