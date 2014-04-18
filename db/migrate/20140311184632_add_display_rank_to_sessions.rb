class AddDisplayRankToSessions < ActiveRecord::Migration
  def change
    add_column :event_sessions, :display_rank, :integer, after: :sponsor_id
  end
end
