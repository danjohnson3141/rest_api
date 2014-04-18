class RenameBreakoutInEventSession < ActiveRecord::Migration
  def change
    remove_column :event_sessions, :breakout_id
    add_column :event_sessions, :breakout_group_id, :integer, after: :sponsor_id
    add_foreign_key :event_sessions, :groups, column: :breakout_group_id
  end
end
