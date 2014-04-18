class RenameEventEvaluationsColumn < ActiveRecord::Migration
  def change
    drop_table :event_evaluations

    create_table :event_evaluations do |t|
      t.string   :survey_link
      t.integer  :event_id
      t.integer  :created_by
      t.integer  :updated_by
      t.datetime :created_at
      t.datetime :updated_at
    end

    add_index :event_evaluations, [:created_by], name: "index_event_evaluations_on_created_by", using: :btree
    add_index :event_evaluations, [:event_id], name: "index_event_evaluations_on_event_id", using: :btree
    add_index :event_evaluations, [:updated_by], name: "index_event_evaluations_on_updated_by", using: :btree

    add_foreign_key :event_evaluations, :events, name: "event_evaluations_event_id_fk"
    add_foreign_key :event_evaluations, :users, name: "event_evaluations_created_by_fk", column: "created_by"
    add_foreign_key :event_evaluations, :users, name: "event_evaluations_updated_by_fk", column: "updated_by"
  end
end
