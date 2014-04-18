class RemoveEventSessionPosts < ActiveRecord::Migration
  def change
    add_reference :event_sessions, :event, after: :sponsor_id
    add_foreign_key :event_sessions, :events

    add_reference :posts, :event, after: :group_id
    add_reference :posts, :event_session, after: :event_id, unique: true
    add_foreign_key :posts, :events
    add_foreign_key :posts, :event_sessions

    drop_table :event_session_posts
  end
end
