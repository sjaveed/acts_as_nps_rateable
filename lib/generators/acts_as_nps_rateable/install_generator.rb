require 'rails/generators/migration'

module ActsAsNpsRateable
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_nps_rateable_migrations
      migration_mapping = {
          '01-migration' => 'acts_as_nps_rateable_migration',
          '02-migration' => 'acts_as_nps_rateable_migration_upgrade_0_0_2',
          '03-migration' => 'acts_as_nps_rateable_migration_upgrade_0_0_5',
          '04-migration' => 'acts_as_nps_rateable_migration_usefulness_upgrade'
      }

      migration_mapping.keys.sort.each do |src|
        tgt = migration_mapping[src]

        if self.class.migration_exists? 'db/migrate', tgt
          puts "Not over-writing existing migration: #{tgt}"
        else
          migration_template "#{src}.rb", "db/migrate/#{tgt}.rb"
          sleep 1
        end
      end
    end

    def install_models
    end
  end
end
