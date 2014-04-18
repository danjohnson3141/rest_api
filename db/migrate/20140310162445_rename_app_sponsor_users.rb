class RenameAppSponsorUsers < ActiveRecord::Migration
  def change
    drop_table :app_sponsor_users

    create_table :sponsor_users do |t|
      t.references :user, index: true
      t.references :sponsor, index: true
      t.integer :created_by
      t.integer :updated_by
      t.foreign_key :users
      t.foreign_key :sponsors
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
      t.timestamps
    end
    add_index :sponsor_users, :created_by
    add_index :sponsor_users, :updated_by
    add_index :sponsor_users, [:sponsor_id, :user_id], unique: true, name: "unique_user_and_sponsor"
  end
end
