class CreateAppSettingDependencies < ActiveRecord::Migration
  def change
    create_table :app_setting_dependencies do |t|
      t.references :app_setting_option, index: true, null: false
      t.integer :dependent_app_setting_option_id, index: true, null: false

      t.timestamps
    end
  end
end
