class UpdateRegStatInEventUsersNotNull < ActiveRecord::Migration
  def change
    change_column :event_users, :event_registration_status_id, :integer, :null => false
  end
end
