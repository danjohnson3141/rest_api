class ChangeBoolenForConnections < ActiveRecord::Migration
  def change
    change_column :connections, :is_recipient_approved, :boolean, :default => 0, :null => false
  end
end
