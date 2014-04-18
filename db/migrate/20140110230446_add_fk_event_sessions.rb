class AddFkEventSessions < ActiveRecord::Migration
  def up
    change_table :event_session_evaluations do |t|
      # t.foreign_key :events
      t.foreign_key :event_sessions
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_session_evaluations do |t|
      # t.remove_foreign_key :events
      t.remove_foreign_key :event_sessions
    end
    remove_foreign_key(:event_session_evaluations, name: 'event_session_evaluations_created_by_fk')
    remove_foreign_key(:event_session_evaluations, name: 'event_session_evaluations_updated_by_fk')
  end
end
