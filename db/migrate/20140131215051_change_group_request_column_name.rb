class ChangeGroupRequestColumnName < ActiveRecord::Migration
  def change
    rename_column :group_requests, :denied, :is_approved
  end
end
