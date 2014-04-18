class RenameUserEventNotesAndBookmarksTables < ActiveRecord::Migration
  def change
    execute "RENAME TABLE `user_event_notes` TO `event_notes`;"
    execute "RENAME TABLE user_event_bookmarks TO event_bookmarks"
  end
end
