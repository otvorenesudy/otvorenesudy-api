class RefactorObcanJusticeSkTables < ActiveRecord::Migration[7.1]
  def up
    drop_table :obcan_justice_sk_courts
    drop_table :obcan_justice_sk_judges
    drop_table :obcan_justice_sk_hearings
    drop_table :obcan_justice_sk_decrees

    %i[courts judges civil_hearings criminal_hearings decrees].each do |table|
      create_table :"obcan_justice_sk_#{table}" do |t|
        t.string :guid, null: false
        t.string :uri, null: false
        t.jsonb :data, null: false, default: '{}'
        t.string :checksum, null: false

        t.timestamps null: false
      end

      add_index :"obcan_justice_sk_#{table}", :guid, unique: true
      add_index :"obcan_justice_sk_#{table}", :uri, unique: true
      add_index :"obcan_justice_sk_#{table}", :checksum, unique: true
      add_index :"obcan_justice_sk_#{table}", :data, using: :gin
    end
  end

  def down
    # Irrelevant for this migration
  end
end
