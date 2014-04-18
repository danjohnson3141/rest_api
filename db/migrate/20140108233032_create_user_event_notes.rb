class CreateUserEventNotes < ActiveRecord::Migration
  def change
    create_table :user_event_notes do |t|
      t.text :body
      t.integer :event_user_id
      t.integer :event_speaker_id
      t.integer :event_session_id
      t.integer :event_sponsor_id
      t.integer :event_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :user_event_notes, :event_user_id
    add_index :user_event_notes, :event_speaker_id
    add_index :user_event_notes, :event_session_id
    add_index :user_event_notes, :event_sponsor_id
    add_index :user_event_notes, :event_id
    add_index :user_event_notes, :created_by
    add_index :user_event_notes, :updated_by
  end
end
