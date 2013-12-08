class ActsAsNpsRateableMigration < ActiveRecord::Migration
  def change
    create_table :nps_ratings do |t|
      t.integer :score
      t.integer :nps_rateable_id
      t.string  :nps_rateable_type
      t.integer :user_id

      t.timestamps
    end

    add_index :nps_ratings, [:nps_rateable_type, :nps_rateable_id, :user_id], unique: true, name: "acts_as_nps_rateable_unique_index"
  end
end
