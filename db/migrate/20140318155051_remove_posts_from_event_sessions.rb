class RemovePostsFromEventSessions < ActiveRecord::Migration
  def change
    remove_foreign_key :event_sessions, :posts
    remove_column :event_sessions, :post_id, :integer    
  end
end
