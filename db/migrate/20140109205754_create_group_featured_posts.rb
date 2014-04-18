class CreateGroupFeaturedPosts < ActiveRecord::Migration
  def change
    create_table :group_featured_posts do |t|
      t.references :post, index: true
      t.references :group, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :group_featured_posts, :created_by
    add_index :group_featured_posts, :updated_by
  end
end
