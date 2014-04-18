class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.text :body
      t.references :user, index: true
      t.references :post, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_comments, :created_by
    add_index :post_comments, :updated_by
  end
end
