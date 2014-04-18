class UpdateNotificationsAgain < ActiveRecord::Migration
  def change
    add_reference :notifications, :event, after: :user_id
    add_reference :notifications, :group_invite, after: :group_id
    add_foreign_key :notifications, :events
    add_foreign_key :notifications, :group_invites
  end
end
