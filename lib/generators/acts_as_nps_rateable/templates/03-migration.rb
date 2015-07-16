class ActsAsNpsRateableMigrationUpgrade005 < ActiveRecord::Migration
  def change
    remove_index :nps_ratings, column: [:nps_rateable_type, :nps_rateable_id, :user_id], unique: true, name: "acts_as_nps_rateable_unique_index"

    rename_column :nps_ratings, :user_id, :rater_id
    add_column :nps_ratings, :rater_type, :string, default: 'User'

    add_index :nps_ratings, [:nps_rateable_type, :nps_rateable_id, :rater_type, :rater_id], unique: true, name: "acts_as_nps_rateable_unique_index"
  end
end
