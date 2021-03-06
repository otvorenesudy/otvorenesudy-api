class CreateInfoSudJudges < ActiveRecord::Migration[5.0]
  def change
    create_table :info_sud_judges do |t|
      t.string :guid, null: false
      t.jsonb :data, null: false, default: '{}'
      t.timestamps
    end

    add_index :info_sud_judges, :guid, unique: true
  end
end
