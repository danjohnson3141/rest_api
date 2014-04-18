class RenameFieldInNotifications < ActiveRecord::Migration
  def change
    remove_foreign_key :notifications, name: "notifications_connection_id_fk"
    rename_column :notifications, :connection_id, :user_connection_id
    add_foreign_key :notifications, :user_connections
  end
end
