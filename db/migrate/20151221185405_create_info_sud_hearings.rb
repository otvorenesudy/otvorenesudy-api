class CreateInfoSudHearings < ActiveRecord::Migration
  def change
    create_table :info_sud_hearings do |t|
      t.string :url, null: false, limit: 2048
      t.string :guid, null: false
      t.jsonb :data, null: false, default: '{}'
      t.timestamps
    end

    add_index :info_sud_hearings, :guid, unique: true
  end
end
