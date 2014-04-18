class CreateMessageAttachments < ActiveRecord::Migration
  def change
    create_table :message_attachments do |t|
      t.references :message, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :message_attachments, :created_by
    add_index :message_attachments, :updated_by
  end
end
