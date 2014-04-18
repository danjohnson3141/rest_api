class AddFkEventUserSchedules < ActiveRecord::Migration
  def up
    change_table :event_user_schedules do |t|
      t.foreign_key :event_users
      t.foreign_key :event_sessions
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_user_schedules do |t|
      t.remove_foreign_key :event_users
      t.remove_foreign_key :event_sessions
    end
    remove_foreign_key(:event_user_schedules, name: 'event_user_schedules_created_by_fk')
    remove_foreign_key(:event_user_schedules, name: 'event_user_schedules_updated_by_fk')
  end
end
