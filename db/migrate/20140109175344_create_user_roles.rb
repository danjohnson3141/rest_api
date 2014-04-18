class CreateUserRoles < ActiveRecord::Migration
  def change
    create_table :user_roles do |t|
      t.string :name, limit: 30
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :user_roles, :created_by
    add_index :user_roles, :updated_by
  end
end
