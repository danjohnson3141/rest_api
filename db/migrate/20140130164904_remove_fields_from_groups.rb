class RemoveFieldsFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :group_is_visible
    remove_column :groups, :group_is_leavable
    remove_column :groups, :show_member_list
  end
end
