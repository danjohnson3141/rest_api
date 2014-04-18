class AddFksToEventSessions < ActiveRecord::Migration
  def change
    add_foreign_key :event_sessions, :events
    add_foreign_key :event_sessions, :posts
    add_foreign_key :event_sessions, :event_sponsors
  end
end
