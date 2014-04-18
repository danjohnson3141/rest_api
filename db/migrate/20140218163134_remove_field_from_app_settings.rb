class RemoveFieldFromAppSettings < ActiveRecord::Migration
  def change
    remove_column :app_settings, :is_setting_enabled, :boolean
  end
end
