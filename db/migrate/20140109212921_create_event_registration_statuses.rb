class CreateEventRegistrationStatuses < ActiveRecord::Migration
  def change
    create_table :event_registration_statuses do |t|
      t.string :name, limit: 50
      t.string :description, limit: 100
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_registration_statuses, :created_by
    add_index :event_registration_statuses, :updated_by
  end
end
