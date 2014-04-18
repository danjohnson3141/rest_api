class AddFkGroupFeaturedPosts < ActiveRecord::Migration
  def up
    change_table :group_featured_posts do |t|
      t.foreign_key :groups
      t.foreign_key :posts
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :group_featured_posts do |t|
      t.remove_foreign_key :groups
      t.remove_foreign_key :posts
    end
    remove_foreign_key(:group_featured_posts, name: 'group_featured_posts_created_by_fk')
    remove_foreign_key(:group_featured_posts, name: 'group_featured_posts_updated_by_fk')
  end
end
