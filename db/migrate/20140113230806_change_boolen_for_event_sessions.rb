class ChangeBoolenForEventSessions < ActiveRecord::Migration
  def change
    change_column :event_sessions, :is_comments_on, :boolean, :default => 0, :null => false
  end
end
