require 'rails/generators/migration'

class ActsAsNpsRateableGenerator < Rails::Generators::Base
  include Rails::Generators::Migration

  source_root File.expand_path('../templates', __FILE__)

  def self.next_migration_number(path)
    Time.now.utc.strftime("%Y%m%d%H%M%S")
  end

  def copy_migration_file
    migration_template 'migration.rb', 'db/migrate/acts_as_nps_rateable_migration'
  end
end