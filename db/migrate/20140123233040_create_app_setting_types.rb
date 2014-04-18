class CreateAppSettingTypes < ActiveRecord::Migration
  def change
    create_table :app_setting_types do |t|
      t.string :name, limit: 50, null: false
      t.string :description, null: false

      t.timestamps
    end
    add_index :app_setting_types, :name, :unique => true
  end
end
