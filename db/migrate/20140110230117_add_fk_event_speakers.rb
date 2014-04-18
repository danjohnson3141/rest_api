class AddFkEventSpeakers < ActiveRecord::Migration
  def up
    change_table :event_speakers do |t|
      t.foreign_key :users
      t.foreign_key :event_sessions
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_speakers do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :event_sessions
    end
    remove_foreign_key(:event_speakers, name: 'event_speakers_created_by_fk')
    remove_foreign_key(:event_speakers, name: 'event_speakers_updated_by_fk')
  end
end
