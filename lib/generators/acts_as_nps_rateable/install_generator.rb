require 'rails/generators/migration'

module ActsAsNpsRateable
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_nps_rateable_migrations
      migration_template '01-migration.rb', 'db/migrate/acts_as_nps_rateable_migration.rb'
      sleep 1
      migration_template '02-migration.rb', 'db/migrate/acts_as_nps_rateable_migration_upgrade_0_0_2.rb'
      sleep 1
      migration_template '03-migration.rb', 'db/migrate/acts_as_nps_rateable_migration_upgrade_0_0_5.rb'
    end

    def install_models
    end
  end
end
