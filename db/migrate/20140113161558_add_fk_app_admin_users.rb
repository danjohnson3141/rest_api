class AddFkAppAdminUsers < ActiveRecord::Migration
  def up
    change_table :app_admin_users do |t|
      t.foreign_key :users
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
    end
  end
  def down
    remove_foreign_key(:app_admin_users, name: 'app_admin_users_created_by_fk')
    remove_foreign_key(:app_admin_users, name: 'app_admin_users_updated_by_fk')
    remove_foreign_key(:app_admin_users, :users)
  end
end
