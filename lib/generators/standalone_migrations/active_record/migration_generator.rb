module StandaloneMigrations
  module ActiveRecord
    class MigrationGenerator < ::ActiveRecord::Generators::MigrationGenerator
      source_root self.superclass.source_root

      def create_migration_file
        set_local_assigns!
        validate_file_name!
        migration_template @migration_template, "#{migration_dir}/#{file_name}.rb"
      end

      protected

      def migration_dir
        Rails.application.config.paths["db/migrate"].first
      end
    end
  end
end
