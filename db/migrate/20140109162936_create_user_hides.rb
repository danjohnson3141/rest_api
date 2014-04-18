class CreateUserHides < ActiveRecord::Migration
  def change
    create_table :user_hides do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.references :post_comment, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :user_hides, :created_by
    add_index :user_hides, :updated_by
  end
end
