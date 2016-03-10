class CreateApiKeys < ActiveRecord::Migration[5.0]
  def change
    create_table :api_keys do |t|
      t.string :value, null: false

      t.timestamps
    end

    add_index :api_keys, :value, unique: true
  end
end
