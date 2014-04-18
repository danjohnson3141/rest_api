class RemoveColumnFromBookmarks < ActiveRecord::Migration
  def change
    remove_foreign_key :event_bookmarks, name: 'user_event_bookmarks_event_id_fk'
    remove_column :event_bookmarks, :event_id
  end
end
