class AddFkUsers < ActiveRecord::Migration
  def up
  	change_table :users do |t|
      t.foreign_key :user_roles
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :users do |t|
      t.remove_foreign_key :user_roles
  end
    remove_foreign_key(:users, name: 'users_created_by_fk')
    remove_foreign_key(:users, name: 'users_updated_by_fk')
  end
end
