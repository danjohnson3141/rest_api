class AddUserRoleToEventEvals < ActiveRecord::Migration
  def change
    add_reference :event_evaluations, :user_role, after: :event_id
    add_foreign_key :event_evaluations, :user_roles
  end
end
