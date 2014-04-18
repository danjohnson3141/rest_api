class AddFkToSponsorAttachments < ActiveRecord::Migration
  def up
  	change_table :sponsor_attachments do |t|
      t.foreign_key :event_sponsors
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :sponsor_attachments do |t|
      t.remove_foreign_key :event_sponsors
    end
  end
end
