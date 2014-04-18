class CreateEventSessionPosts < ActiveRecord::Migration
  def change
    create_table :event_session_posts do |t|
      t.references :event, index: true, null: false
      t.references :event_session, index: true, unique: true
      t.references :post, index: true, unique: true

      t.timestamps
    end
    add_foreign_key :event_session_posts, :events
    add_foreign_key :event_session_posts, :posts
    add_foreign_key :event_session_posts, :event_sessions
    add_index :event_session_posts, [:event_id, :event_session_id, :post_id], unique: true, name: "unique_event_session_post"

  end
end
