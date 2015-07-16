class ActsAsNpsRateableMigrationUpgrade002 < ActiveRecord::Migration
  def change
    add_column :nps_ratings, :comments, :text
  end
end
