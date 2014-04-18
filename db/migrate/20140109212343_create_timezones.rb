class CreateTimezones < ActiveRecord::Migration
  def change
    create_table :timezones do |t|
      t.string :name, limit: 50
      t.integer :offset
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :timezones, :created_by
    add_index :timezones, :updated_by
  end
end
