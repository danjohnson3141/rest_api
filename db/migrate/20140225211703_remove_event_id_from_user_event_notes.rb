class RemoveEventIdFromUserEventNotes < ActiveRecord::Migration
  def change
    remove_column :user_event_notes, :event_id
  end
end
