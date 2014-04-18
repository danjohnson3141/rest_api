class UpdatesToGroupRequests < ActiveRecord::Migration
  def change
    remove_column :group_requests, :pre_auth, :boolean
    remove_column :group_requests, :approved, :boolean
    add_column :group_requests, :denied, :boolean, :default => 0, :null => false, :after => :group_id
  end
end
