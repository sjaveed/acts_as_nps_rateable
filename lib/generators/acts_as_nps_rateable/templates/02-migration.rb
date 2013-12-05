class ActsAsNpsRateableMigration < ActiveRecord::Migration
  def change
    add_column :nps_ratings, :comments, :text
  end
end
