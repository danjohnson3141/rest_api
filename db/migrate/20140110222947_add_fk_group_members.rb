class AddFkGroupMembers < ActiveRecord::Migration
  def up
  	change_table :group_members do |t|
      t.foreign_key :users
      t.foreign_key :groups
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :group_members do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :groups
    end
    remove_foreign_key(:group_members, name: 'group_members_created_by_fk')
    remove_foreign_key(:group_members, name: 'group_members_updated_by_fk')
  end
end
