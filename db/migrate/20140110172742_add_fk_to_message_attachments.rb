class AddFkToMessageAttachments < ActiveRecord::Migration
  def up
  	change_table :message_attachments do |t|
      t.foreign_key :messages
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :message_attachments do |t|
      t.remove_foreign_key :messages
    end
  end
end
