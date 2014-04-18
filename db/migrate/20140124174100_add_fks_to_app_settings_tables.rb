class AddFksToAppSettingsTables < ActiveRecord::Migration
  def change
    add_foreign_key(:app_setting_options, :app_setting_types)
    add_foreign_key(:app_setting_dependencies, :app_setting_options)
    # add_foreign_key(:app_setting_dependencies, :app_setting_options, column: 'dependent_app_setting_option_id')
    execute "ALTER TABLE `app_setting_dependencies` ADD FOREIGN KEY (`dependent_app_setting_option_id`) REFERENCES `app_setting_options` (`id`);"

  end
end
