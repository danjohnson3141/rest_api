class AddFkToPostComments < ActiveRecord::Migration
  def up
  	change_table :post_comments do |t|
      t.foreign_key :users
      t.foreign_key :posts
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :post_comments do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :posts
    end
  end
end
