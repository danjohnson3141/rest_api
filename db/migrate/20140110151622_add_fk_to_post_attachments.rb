class AddFkToPostAttachments < ActiveRecord::Migration
  def up
  	change_table :post_attachments do |t|
      t.foreign_key :posts
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :post_attachments do |t|
      t.remove_foreign_key :posts
    end
  end
end
