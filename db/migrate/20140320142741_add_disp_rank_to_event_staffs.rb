class AddDispRankToEventStaffs < ActiveRecord::Migration
  def change
    drop_table :event_staffs
    create_table :event_staff_users
    add_reference :event_staff_users, :event, index: true
    add_reference :event_staff_users, :user, index: true
    add_column :event_staff_users, :display_rank, :integer, index: true
    add_column :event_staff_users, :created_by, :integer
    add_column :event_staff_users, :updated_by, :integer
    add_column :event_staff_users, :created_at, :timestamp
    add_column :event_staff_users, :updated_at, :timestamp

    add_foreign_key :event_staff_users, :users
    add_foreign_key :event_staff_users, :events
    add_foreign_key :event_staff_users, :users, column: 'updated_by'
    add_foreign_key :event_staff_users, :users, column: 'created_by'
  end
end
