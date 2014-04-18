class CreateEventSponsors < ActiveRecord::Migration
  def change
    create_table :event_sponsors do |t|
      t.string :name
      t.text :description
      t.string :logo
      t.string :url
      t.references :event, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_sponsors, :created_by
    add_index :event_sponsors, :updated_by
  end
end
