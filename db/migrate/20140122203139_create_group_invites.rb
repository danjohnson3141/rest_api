class CreateGroupInvites < ActiveRecord::Migration
  def change
    create_table :group_invites do |t|
      t.references :user, index: true
      t.references :group, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :group_invites, :created_by
    add_index :group_invites, :updated_by
  end
end
