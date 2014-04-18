class UpdateNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notification_user_id, :integer, after: :body
    remove_column :notifications, :link, :string
    add_foreign_key :notifications, :users, column: :notification_user_id
  end
end
