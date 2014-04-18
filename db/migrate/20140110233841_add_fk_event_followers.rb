class AddFkEventFollowers < ActiveRecord::Migration
  def up
    change_table :event_followers do |t|
      t.foreign_key :events
      t.foreign_key :users
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_followers do |t|
      t.remove_foreign_key :events
      t.remove_foreign_key :users
    end
    remove_foreign_key(:event_followers, name: 'event_followers_created_by_fk')
    remove_foreign_key(:event_followers, name: 'event_followers_updated_by_fk')
  end
end
