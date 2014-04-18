class AddUniquenessToAppSettings < ActiveRecord::Migration
  def change
    add_column :app_settings, :app_level_setting, :boolean, after: "app_setting_option_id"
    add_index :app_settings, [:app_setting_option_id, :app_level_setting], unique: true, name: "unique_app_setting_option_id"
    add_index :app_settings, [:app_setting_option_id, :event_id], unique: true, name: "unique_event_id"
    add_index :app_settings, [:app_setting_option_id, :group_id], unique: true, name: "unique_group_id"
    add_index :app_settings, [:app_setting_option_id, :user_role_id], unique: true, name: "unique_user_role_id"
    add_index :app_settings, [:app_setting_option_id, :user_id], unique: true, name: "unique_user_id"
  end
end
