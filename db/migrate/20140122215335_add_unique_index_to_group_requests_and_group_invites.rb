class AddUniqueIndexToGroupRequestsAndGroupInvites < ActiveRecord::Migration
  def change
    add_index :group_invites, [:group_id, :user_id], :unique => true, :name => 'index_group_invites_on_group_id_and_user_id'
    add_index :group_requests, [:group_id, :user_id], :unique => true, :name => 'index_group_requests_on_group_id_and_user_id'
  end
end
