class ChangeBoolenForGroups < ActiveRecord::Migration
  def change
    change_column :groups, :group_is_visible, :boolean, :default => 0, :null => false
    change_column :groups, :group_is_leavable, :boolean, :default => 0, :null => false
    change_column :groups, :show_member_list, :boolean, :default => 0, :null => false
  end
end
