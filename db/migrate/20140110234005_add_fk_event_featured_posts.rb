class AddFkEventFeaturedPosts < ActiveRecord::Migration
  def up
    change_table :event_featured_posts do |t|
      t.foreign_key :events
      t.foreign_key :posts
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_featured_posts do |t|
      t.remove_foreign_key :events
      t.remove_foreign_key :posts
    end
    remove_foreign_key(:event_featured_posts, name: 'event_featured_posts_created_by_fk')
    remove_foreign_key(:event_featured_posts, name: 'event_featured_posts_updated_by_fk')
  end
end
