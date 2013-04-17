require 'rails/generators/migration'

module ActsAsNpsRateable
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def create_migration
      migration_template 'migration.rb', 'db/migrate/acts_as_nps_rateable_migration'
    end

    def install_models
      template 'nps_rating.rb', 'app/models/nps_rating.rb'
    end
  end
end
