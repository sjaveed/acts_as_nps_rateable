class ActsAsNpsRateableMigrationUsefulnessUpgrade < ActiveRecord::Migration
  def change
    add_column :nps_ratings, :up_votes, :integer, default: 0, null: false
    add_column :nps_ratings, :down_votes, :integer, default: 0, null: false
    add_column :nps_ratings, :net_votes, :integer, default: 0, null: false

    add_column :nps_ratings, :response, :text
    add_column :nps_ratings, :responded_at, :timestamp
  end
end
