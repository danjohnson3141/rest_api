class CreatePostCommentsAttachments < ActiveRecord::Migration
  def change
    create_table :post_comments_attachments do |t|
      t.references :post_comment, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_comments_attachments, :created_by
    add_index :post_comments_attachments, :updated_by
  end
end
