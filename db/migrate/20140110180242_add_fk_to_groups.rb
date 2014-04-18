class AddFkToGroups < ActiveRecord::Migration
  def up
  	change_table :groups do |t|
      t.foreign_key :group_types
      t.foreign_key :app_sponsors
      t.foreign_key :users, column: 'owner_user_id'
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
    change_table :groups do |t|
      t.remove_foreign_key :group_types
      t.remove_foreign_key :app_sponsors
      t.remove_foreign_key :users, column: 'owner_user_id'
      t.remove_foreign_key :users, column: 'created_by'
      t.remove_foreign_key :users, column: 'updated_by'
    end
  end
end
