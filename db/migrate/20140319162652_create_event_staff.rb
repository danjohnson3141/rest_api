class CreateEventStaff < ActiveRecord::Migration
  def change
    create_table :event_staffs
    add_reference :event_staffs, :event, index: true
    add_reference :event_staffs, :user, index: true
    add_column :event_staffs, :created_by, :integer
    add_column :event_staffs, :updated_by, :integer
    add_column :event_staffs, :created_at, :timestamp
    add_column :event_staffs, :updated_at, :timestamp

    add_foreign_key :event_staffs, :users
    add_foreign_key :event_staffs, :events
    add_foreign_key :event_staffs, :users, column: 'updated_by'
    add_foreign_key :event_staffs, :users, column: 'created_by'
  end
end
