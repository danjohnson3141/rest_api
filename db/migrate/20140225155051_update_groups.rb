class UpdateGroups < ActiveRecord::Migration
  def change
    change_column :groups, :owner_user_id, :integer, :default => 0, :null => false
  end
end
