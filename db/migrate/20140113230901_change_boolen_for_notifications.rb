class ChangeBoolenForNotifications < ActiveRecord::Migration
  def change
    change_column :notifications, :is_viewed, :boolean, :default => 0, :null => false
  end
end
