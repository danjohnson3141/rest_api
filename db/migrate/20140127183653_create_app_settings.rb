class CreateAppSettings < ActiveRecord::Migration
  def change
    create_table :app_settings do |t|
      t.boolean :is_setting_enabled, null: false, default: 0
      t.references :app_setting_option, index: true, null: false
      t.references :event, index: true
      t.references :group, index: true
      t.references :user_role, index: true
      t.references :user, index: true
      t.integer :created_by, index: true
      t.integer :updated_by, index: true

      t.timestamps
    end
    change_column :app_settings, :is_setting_enabled, :boolean, :default => 0, :null => false
    add_foreign_key :app_settings, :app_setting_options
    add_foreign_key :app_settings, :events
    add_foreign_key :app_settings, :groups
    add_foreign_key :app_settings, :user_roles
    add_foreign_key :app_settings, :users
    add_foreign_key :app_settings, :users, :column => 'created_by'
    add_foreign_key :app_settings, :users, :column => 'updated_by'
  end
  
end
