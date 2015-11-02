namespace :db do
  namespace :schema do
    # desc 'Dump additional database schema'
    task dump: [:environment, :load_config] do
      require 'active_record/schema_dumper'

      filename = File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, 'opencourts_schema.rb')

      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::Base.establish_connection(:"opencourts_#{Rails.env}")

        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end

  namespace :test do
    # desc 'Purge and load opencourts_test schema'
    task load_schema: [:environment, :load_config] do
      begin
        should_reconnect = ActiveRecord::Base.connection_pool.active_connection?

        ActiveRecord::Tasks::DatabaseTasks.purge(ActiveRecord::Base.configurations['opencourts_test'])
        ActiveRecord::Base.establish_connection(:opencourts_test)
        ActiveRecord::Schema.verbose = false

        filename = File.join(ActiveRecord::Tasks::DatabaseTasks.db_dir, 'opencourts_schema.rb')
        ActiveRecord::Tasks::DatabaseTasks.load_schema(ActiveRecord::Base.configurations['opencourts_test'], :ruby, filename)
      ensure
        if should_reconnect
          ActiveRecord::Base.establish_connection(ActiveRecord::Base.configurations[ActiveRecord::Tasks::DatabaseTasks.env])
        end
      end
    end
  end
end
