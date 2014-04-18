class CreatePostCommentAttachments < ActiveRecord::Migration
  def change
    execute "DROP TABLE post_comments_attachments;"
    create_table :post_comment_attachments do |t|
      t.references :post_comment, index: true
      t.string :url
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_comment_attachments, :created_by
    add_index :post_comment_attachments, :updated_by
    add_foreign_key :post_comment_attachments, :post_comments
  end
end
