class AddFkGroupRequests < ActiveRecord::Migration
  def up
  	change_table :group_requests do |t|
      t.foreign_key :users
      t.foreign_key :groups
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :group_requests do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :groups
    end
    remove_foreign_key(:group_requests, name: 'group_requests_created_by_fk')
    remove_foreign_key(:group_requests, name: 'group_requests_updated_by_fk')
  end
end
