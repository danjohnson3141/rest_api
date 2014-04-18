class CreateEventLeaderboardOptions < ActiveRecord::Migration
  def change
    create_table :event_leaderboard_options do |t|
      t.string :name, limit: 30
      t.string :description
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_leaderboard_options, :created_by
    add_index :event_leaderboard_options, :updated_by
  end
end
