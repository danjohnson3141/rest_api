class CreatePostHides < ActiveRecord::Migration
  def change
    create_table :post_hides do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_hides, :created_by
    add_index :post_hides, :updated_by
  end
end
