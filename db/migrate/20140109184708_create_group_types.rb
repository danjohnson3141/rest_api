class CreateGroupTypes < ActiveRecord::Migration
  def change
    create_table :group_types do |t|
      t.string :name, limit: 50
      t.string :description, limit: 100
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :group_types, :created_by
    add_index :group_types, :updated_by
  end
end
