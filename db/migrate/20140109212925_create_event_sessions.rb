class CreateEventSessions < ActiveRecord::Migration
  def change
    create_table :event_sessions do |t|
      t.string :name
      t.text :description
      t.datetime :start_date_time
      t.datetime :end_date_time
      t.string :track_name, limit: 100
      t.string :breakout_id
      t.string :session_type, limit: 100
      t.string :room_name, limit: 100
      t.boolean :is_comments_on
      t.references :event, index: true
      t.integer :post_id
      t.references :event_sponsor, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_sessions, :post_id
    add_index :event_sessions, :created_by
    add_index :event_sessions, :updated_by
  end
end
