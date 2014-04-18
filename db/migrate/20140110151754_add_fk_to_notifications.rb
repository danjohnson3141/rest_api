class AddFkToNotifications < ActiveRecord::Migration
  def up
  	change_table :notifications do |t|
      t.foreign_key :users
      t.foreign_key :groups
      t.foreign_key :posts
      t.foreign_key :connections
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :notifications do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :groups
      t.remove_foreign_key :posts
      t.remove_foreign_key :connections
    end
  end
end
