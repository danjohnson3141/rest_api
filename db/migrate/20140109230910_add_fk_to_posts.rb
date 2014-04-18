class AddFkToPosts < ActiveRecord::Migration
  def up
  	change_table :posts do |t|
      t.foreign_key :groups
      t.foreign_key :users
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :posts do |t|
      t.remove_foreign_key :groups
      t.remove_foreign_key :users
    end
  end
end
