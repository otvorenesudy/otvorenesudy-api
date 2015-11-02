class CreateApiKeys < ActiveRecord::Migration
  def change
    create_table :api_keys do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :api_keys, :value, unique: true
  end
end
