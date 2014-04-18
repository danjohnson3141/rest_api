class AddAuthRequiredToAppLabelPages < ActiveRecord::Migration
  def change
    change_column :users, :first_name, :string, :null => false, :limit => 100
    change_column :users, :last_name, :string, :null => false, :limit => 100
    execute "RENAME TABLE `connections` TO `user_connections`";
    add_column :app_label_pages, :auth_required, :boolean, :null => false, default: 1, :after => 'description'
    rename_column :user_connections, :is_recipient_approved, :is_approved
  end
end
