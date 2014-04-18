class AddFkToPostCommentsAttachments < ActiveRecord::Migration
  def up
  	change_table :post_comments_attachments do |t|
      t.foreign_key :post_comments
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :post_comments_attachments do |t|
      t.remove_foreign_key :post_comments
    end
  end
end
