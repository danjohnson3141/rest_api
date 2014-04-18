class AddUniqueIndexToGroupMembers < ActiveRecord::Migration
  def change
    add_index :group_members, [:group_id, :user_id], :unique => true, :name => 'index_group_members_on_group_id_and_user_id'
  end
end
