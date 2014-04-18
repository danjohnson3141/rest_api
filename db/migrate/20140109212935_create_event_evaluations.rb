class CreateEventEvaluations < ActiveRecord::Migration
  def change
    create_table :event_evaluations do |t|
      t.string :survey_link
      t.integer :event_session_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_evaluations, :event_session_id
    add_index :event_evaluations, :created_by
    add_index :event_evaluations, :updated_by
  end
end
