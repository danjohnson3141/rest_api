class CreateNotifications < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.boolean :is_viewed
      t.text :body
      t.string :link
      t.string :type
      t.integer :user_id
      t.integer :group_id
      t.integer :post_id
      t.integer :connection_id
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
  end
end
