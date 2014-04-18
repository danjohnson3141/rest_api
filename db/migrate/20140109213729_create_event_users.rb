class CreateEventUsers < ActiveRecord::Migration
  def change
    create_table :event_users do |t|
      t.references :event_registration_status, index: true
      t.references :user, index: true
      t.references :event, index: true
      t.references :event_sponsor, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_users, :created_by
    add_index :event_users, :updated_by
    add_index :event_users, [:event_id, :user_id], :unique => true
    add_foreign_key :event_users, :users
    add_foreign_key :event_users, :events
    add_foreign_key :event_users, :event_sponsors
    add_foreign_key :event_users, :event_registration_statuses
    add_foreign_key :event_users, :users, column: 'created_by'
    add_foreign_key :event_users, :users, column: 'updated_by'
  end
end
