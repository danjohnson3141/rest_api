class CreatePostAttachments < ActiveRecord::Migration
  def change
    create_table :post_attachments do |t|
      t.references :post, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_attachments, :created_by
    add_index :post_attachments, :updated_by
  end
end
