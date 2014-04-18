class CreateAppSponsorUsers < ActiveRecord::Migration
  def change
    create_table :app_sponsor_users do |t|
      t.references :user, index: true
      t.references :app_sponsor, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_sponsor_users, :created_by
    add_index :app_sponsor_users, :updated_by
  end
end
