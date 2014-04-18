class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :body
      t.text :body_markdown
      t.text :excerpt
      t.string :thumbnail_teaser_photo
      t.integer :display_rank
      t.integer :view_count
      t.references :group, index: true
      t.references :user, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :posts, :created_by
    add_index :posts, :updated_by
  end
end
