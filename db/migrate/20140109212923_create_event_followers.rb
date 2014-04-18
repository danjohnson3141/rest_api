class CreateEventFollowers < ActiveRecord::Migration
  def change
    create_table :event_followers do |t|
      t.references :user, index: true
      t.references :event, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_followers, :created_by
    add_index :event_followers, :updated_by
  end
end
