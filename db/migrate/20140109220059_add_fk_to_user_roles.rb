class AddFkToUserRoles < ActiveRecord::Migration
  def change
  	change_table :user_roles do |t|
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
end
