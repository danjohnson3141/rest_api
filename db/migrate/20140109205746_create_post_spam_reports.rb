class CreatePostSpamReports < ActiveRecord::Migration
  def change
    create_table :post_spam_reports do |t|
      t.references :user, index: true
      t.references :post, index: true
      t.references :post_comment, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :post_spam_reports, :created_by
    add_index :post_spam_reports, :updated_by
  end
end
