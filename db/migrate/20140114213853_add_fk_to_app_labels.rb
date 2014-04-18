class AddFkToAppLabels < ActiveRecord::Migration
  def up
    change_table :app_labels do |t|
      t.foreign_key :events
      t.foreign_key :app_label_dictionaries
      t.foreign_key :app_languages
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
    end
  end
  def down
    remove_foreign_key(:app_labels, name: 'app_labels_created_by_fk')
    remove_foreign_key(:app_labels, name: 'app_labels_updated_by_fk')
    remove_foreign_key(:app_labels, :events)
    remove_foreign_key(:app_labels, :app_label_dictionaries)
    remove_foreign_key(:app_labels, :app_languages)
  end
end
