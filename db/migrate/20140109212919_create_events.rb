class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.date :begin_date
      t.date :end_date
      t.string :venue_name
      t.string :address
      t.string :state, limit: 4
      t.string :postal_code, limit: 20
      t.references :country, index: true
      t.references :timezone, index: true
      t.references :group, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :events, :created_by
    add_index :events, :updated_by
  end
end
