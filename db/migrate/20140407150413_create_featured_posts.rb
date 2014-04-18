class CreateFeaturedPosts < ActiveRecord::Migration
  def change
    create_table :featured_posts do |t|
      t.references :post, index: true, unique: true, null: false
      t.integer :created_by
      t.integer :updated_by
      t.foreign_key :posts
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
      t.timestamps
    end
    add_index :featured_posts, :created_by
    add_index :featured_posts, :updated_by
  end
end
