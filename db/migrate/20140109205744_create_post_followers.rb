class CreatePostFollowers < ActiveRecord::Migration
  def change
    create_table :post_followers do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_followers, :created_by
    add_index :post_followers, :updated_by
  end
end
