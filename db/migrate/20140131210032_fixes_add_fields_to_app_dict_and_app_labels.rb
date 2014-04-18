class FixesAddFieldsToAppDictAndAppLabels < ActiveRecord::Migration
  def change
    rename_column :app_labels, :plural_label, :label_plural
    rename_column :app_label_dictionaries, :plural_name, :name_plural
  end
end
