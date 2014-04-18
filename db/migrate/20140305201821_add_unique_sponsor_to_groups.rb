class AddUniqueSponsorToGroups < ActiveRecord::Migration
  def change
    execute "UPDATE groups SET app_sponsor_id = NULL"
    remove_foreign_key :groups, :app_sponsors
    remove_index :groups, name: "index_groups_on_app_sponsor_id"
    add_index :groups, :app_sponsor_id, unique: true
    add_foreign_key :groups, :app_sponsors
  end
end
