class CreateAppSettingOptions < ActiveRecord::Migration
  def change
    create_table :app_setting_options do |t|
      t.string :name, null: false
      t.string :description, null: false
      t.references :app_setting_type, index: true
      t.integer :created_by
      t.integer :updated_by
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'

      t.timestamps
    end
    add_index :app_setting_options, [:name, :description, :app_setting_type_id], :unique => true, :name => 'index_app_setting_options_on_name_and_desc_and_app_setting_type'
  end
end
