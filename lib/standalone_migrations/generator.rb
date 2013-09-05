require "rails/generators"
require 'rails/generators/active_record'
require 'rails/generators/active_record/migration/migration_generator'

module StandaloneMigrations
  class Generator
    def self.migration(name, options="")
      generator_params = [name] + options.split(" ")
      Rails::Generators.invoke "standalone_migrations:active_record:migration", generator_params,
      :destination_root => Rails.root
    end
  end
end
