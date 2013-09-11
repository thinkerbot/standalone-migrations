module StandaloneMigrations
  class Tasks
    class << self
      def configure
        Deprecations.new.call
        configurator = Configurator.new

        paths = Rails.application.config.paths
        paths.add "config/database", :with => configurator.config
        paths.add "db/migrate", :with => configurator.migrate_dir
        paths.add "db/seeds", :with => configurator.seeds
        paths.add "db", :with => configurator.db_dir

        ActiveRecord::Tasks::DatabaseTasks.env = ENV["RAILS_ENV"]
        ActiveRecord::Tasks::DatabaseTasks.seed_loader = SeedLoader.new(paths["db/seeds"])
        ActiveRecord::Tasks::DatabaseTasks.db_dir = paths["db"].first
        ActiveRecord::Tasks::DatabaseTasks.migrations_paths = paths["db/migrate"]
        ActiveRecord::Tasks::DatabaseTasks.database_configuration = Rails.application.config.database_configuration
      end

      class SeedLoader
        attr_reader :paths
        def initialize(paths)
          @paths = paths
        end
        def load_seed
          paths.each do |path|
            load path
          end
        end
      end

      def load_tasks
        configure

        MinimalRailtieConfig.load_tasks
        %w(
          connection
          environment
          db/new_migration
        ).each do
          |task| load "standalone_migrations/tasks/#{task}.rake"
        end
        load "active_record/railties/databases.rake"
      end
    end
  end

  class Tasks::Deprecations
    def call
      if File.directory?('db/migrations')
        puts "DEPRECATED move your migrations into db/migrate"
      end
    end
  end
end
