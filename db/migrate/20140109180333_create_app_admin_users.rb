class CreateAppAdminUsers < ActiveRecord::Migration
  def change
    create_table :app_admin_users do |t|
      t.references :user, index: true
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_admin_users, :created_by
    add_index :app_admin_users, :updated_by
  end
end
