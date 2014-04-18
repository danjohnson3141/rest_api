class AddUniqueIndexToEventRegistrationStatus < ActiveRecord::Migration
  def change
    add_index :event_registration_statuses, :key, unique: true
  end
end
