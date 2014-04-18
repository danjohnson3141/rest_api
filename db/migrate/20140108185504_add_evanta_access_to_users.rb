class AddEvantaAccessToUsers < ActiveRecord::Migration
  def change
    add_column :users, :alt_email, :string
    add_column :users, :first_name, :string, limit: 100
    add_column :users, :last_name, :string, limit: 100
    add_column :users, :title, :string
    add_column :users, :organization_name, :string
    add_column :users, :bio, :text
    add_column :users, :photo, :string
    add_column :users, :user_role_id, :integer
    add_index :users, :user_role_id
    add_column :users, :created_by, :integer
    add_index :users, :created_by
    add_column :users, :updated_by, :integer
    add_index :users, :updated_by
  end
end
