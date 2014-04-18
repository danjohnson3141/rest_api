class CreateAppLabelOptions < ActiveRecord::Migration
  def change
    create_table :app_label_options do |t|
      t.string :name, limit: 50
      t.string :description
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_label_options, :created_by
    add_index :app_label_options, :updated_by
  end
end
