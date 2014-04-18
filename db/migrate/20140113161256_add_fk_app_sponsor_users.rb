class AddFkAppSponsorUsers < ActiveRecord::Migration
  def up
    change_table :app_sponsor_users do |t|
      t.foreign_key :users
      t.foreign_key :app_sponsors
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
    end
  end
  def down
    remove_foreign_key(:app_sponsor_users, name: 'app_sponsor_users_created_by_fk')
    remove_foreign_key(:app_sponsor_users, name: 'app_sponsor_users_updated_by_fk')
    remove_foreign_key(:app_sponsor_users, :users)
    remove_foreign_key(:app_sponsor_users, :app_sponsors)
  end
end
