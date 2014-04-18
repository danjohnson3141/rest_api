class CreatePostLikes < ActiveRecord::Migration
  def change
    create_table :post_likes do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_likes, :created_by
    add_index :post_likes, :updated_by
  end
end
