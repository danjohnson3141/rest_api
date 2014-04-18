class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, limit: 100
      t.string :abbreviation, limit: 50
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :countries, :created_by
    add_index :countries, :updated_by
  end
end
