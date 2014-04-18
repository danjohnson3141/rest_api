class CreateEventLeaderboards < ActiveRecord::Migration
  def change
    create_table :event_leaderboards do |t|
      t.integer :points_allocated
      t.integer :event_leaderboard_option_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_leaderboards, :event_leaderboard_option_id
    add_index :event_leaderboards, :created_by
    add_index :event_leaderboards, :updated_by
  end
end
