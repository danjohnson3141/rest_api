class AddFkEventLeaderboards < ActiveRecord::Migration
  def up
    change_table :event_leaderboards do |t|
      t.foreign_key :event_leaderboard_options
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_leaderboards do |t|
      t.remove_foreign_key :event_leaderboard_options
    end
    remove_foreign_key(:event_leaderboards, name: 'event_leaderboards_created_by_fk')
    remove_foreign_key(:event_leaderboards, name: 'event_leaderboards_updated_by_fk')
  end
end
