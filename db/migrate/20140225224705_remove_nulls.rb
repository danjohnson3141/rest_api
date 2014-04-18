class RemoveNulls < ActiveRecord::Migration
  def change
    change_column :event_sessions, :event_id, :integer, null: false
    change_column :event_sponsors, :event_id, :integer, null: false
    change_column :event_sponsors, :event_id, :integer, null: false    
  end
end
