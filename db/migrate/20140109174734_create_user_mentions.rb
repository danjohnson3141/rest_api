class CreateUserMentions < ActiveRecord::Migration
  def change
    create_table :user_mentions do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.references :post_comment, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :user_mentions, :created_by
    add_index :user_mentions, :updated_by
  end
end
