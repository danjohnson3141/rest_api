class AddDisplayRankToEvals < ActiveRecord::Migration
  def change
    add_column :event_evaluations, :display_rank, :integer, index: true, after: :survey_link
    add_column :event_session_evaluations, :display_rank, :integer, index: true, after: :survey_link
  end
end
