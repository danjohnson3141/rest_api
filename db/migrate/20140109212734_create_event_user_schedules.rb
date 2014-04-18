class CreateEventUserSchedules < ActiveRecord::Migration
  def change
    create_table :event_user_schedules do |t|
      t.references :event_session, index: true
      t.references :event_user, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_user_schedules, :created_by
    add_index :event_user_schedules, :updated_by
  end
end
