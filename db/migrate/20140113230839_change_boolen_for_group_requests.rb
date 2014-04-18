class ChangeBoolenForGroupRequests < ActiveRecord::Migration
  def change
    change_column :group_requests, :pre_auth, :boolean, :default => 0, :null => false
    change_column :group_requests, :approved, :boolean, :default => 0, :null => false
  end
end
