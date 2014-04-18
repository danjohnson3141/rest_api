class DropEventGroupFeaturedPostsTables < ActiveRecord::Migration
  def change
    drop_table :event_featured_posts
    drop_table :group_featured_posts
  end
end
