class CreatePublicProsecutorRefinements < ActiveRecord::Migration[5.0]
  def change
    create_table :public_prosecutor_refinements do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :ip_address, null: false
      t.string :prosecutor, null: false
      t.string :office, null: false

      t.timestamps null: false
    end

    add_index :public_prosecutor_refinements, :ip_address
  end
end
