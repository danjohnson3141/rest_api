class CreateAppLabelLanguages < ActiveRecord::Migration
  def change
    create_table :app_label_languages do |t|
      t.string :name, limit: 50
      t.string :description
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :app_label_languages, :created_by
    add_index :app_label_languages, :updated_by
  end
end
