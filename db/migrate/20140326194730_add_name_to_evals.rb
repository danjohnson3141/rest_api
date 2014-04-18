class AddNameToEvals < ActiveRecord::Migration
  def change
    add_column :event_evaluations, :name, :string, after: :survey_link
    add_column :event_session_evaluations, :name, :string, after: :survey_link
    add_foreign_key :group_invites, :users
    add_foreign_key :group_invites, :groups
  end
end
