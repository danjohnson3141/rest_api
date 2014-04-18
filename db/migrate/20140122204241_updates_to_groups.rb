class UpdatesToGroups < ActiveRecord::Migration
  def change
    change_column :groups, :group_type_id, :integer, :null => false, :index => true
  end
end
