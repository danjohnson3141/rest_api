class RemoveColumnFromPosts < ActiveRecord::Migration
  def change
    remove_foreign_key :posts, :events
    remove_column :posts, :event_id, :integer
    remove_foreign_key :event_sessions, :events
    remove_column :event_sessions, :event_id, :integer
  end
end