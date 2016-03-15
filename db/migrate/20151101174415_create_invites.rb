class CreateInvites < ActiveRecord::Migration[5.0]
  def change
    create_table :invites do |t|
      t.string :email,  null: false
      t.string :locale, null: false

      t.timestamps
    end

    add_index :invites, [:email, :locale], unique: true
  end
end
