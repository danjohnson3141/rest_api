class CreateUserEventBookmarks < ActiveRecord::Migration
  def change
    create_table :user_event_bookmarks do |t|
      t.references :event, index: true
      t.references :event_user, index: true
      t.references :event_speaker, index: true
      t.references :event_session, index: true
      t.references :event_sponsor, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :user_event_bookmarks, :created_by
    add_index :user_event_bookmarks, :updated_by
  end
end
