class AddFkToPostSpamReports < ActiveRecord::Migration
  def up
  	change_table :post_spam_reports do |t|
      t.foreign_key :users
      t.foreign_key :posts
      t.foreign_key :post_comments
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :post_spam_reports do |t|
      t.remove_foreign_key :users
      t.remove_foreign_key :posts
      t.remove_foreign_key :post_comments
    end
  end
end
