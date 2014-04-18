class CreateSponsorAttachments < ActiveRecord::Migration
  def change
    create_table :sponsor_attachments do |t|
      t.references :event_sponsor, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :sponsor_attachments, :created_by
    add_index :sponsor_attachments, :updated_by
  end
end
