class AddUrlToPostAttachment < ActiveRecord::Migration
  def change
    add_column :post_attachments, :url, :string, after: "post_id"
    add_column :sponsor_attachments, :url, :string, after: "event_sponsor_id"
    add_foreign_key :user_hides, :post_comments
  end
end
