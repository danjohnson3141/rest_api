class AddFieldsToGroupTypes < ActiveRecord::Migration
  def change
    add_column :group_types, :is_group_visible, :boolean, :null => false, default: 0, :after => 'description'
    add_column :group_types, :is_memberlist_visible, :boolean, :null => false, default: 0, :after => 'is_group_visible'
    add_column :group_types, :is_content_visible, :boolean, :null => false, default: 0, :after => 'is_memberlist_visible'
    add_column :group_types, :is_approval_required, :boolean, :null => false, default: 0, :after => 'is_content_visible'
  end
end
