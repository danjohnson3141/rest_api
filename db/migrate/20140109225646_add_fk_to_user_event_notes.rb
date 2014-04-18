class AddFkToUserEventNotes < ActiveRecord::Migration
  def up
  	change_table :user_event_notes do |t|
      t.foreign_key :event_users
      t.foreign_key :event_speakers
      t.foreign_key :event_sessions
      t.foreign_key :event_sponsors
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :user_event_notes do |t|
      t.remove_foreign_key :event_users
      t.remove_foreign_key :event_speakers
      t.remove_foreign_key :event_sessions
      t.remove_foreign_key :event_sponsors
    end
  end
end
