class CreateEventFeaturedPosts < ActiveRecord::Migration
  def change
    create_table :event_featured_posts do |t|
      t.references :post, index: true
      t.references :event, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :event_featured_posts, :created_by
    add_index :event_featured_posts, :updated_by
  end
end
