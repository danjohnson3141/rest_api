class AddFkToUserMentions < ActiveRecord::Migration
   def up
  	change_table :user_mentions do |t|
      t.foreign_key :users
      t.foreign_key :posts
      t.foreign_key :post_comments
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :user_mentions do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :posts
      t.remove_foreign_key :comments
    end
  end
end
