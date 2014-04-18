class AddFieldsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :sender_deleted, :boolean, after: "viewed_date", default: 0, null: false, index: true
    add_column :messages, :recipient_deleted, :boolean, after: "sender_deleted", default: 0, null: false, index: true
  end
end
