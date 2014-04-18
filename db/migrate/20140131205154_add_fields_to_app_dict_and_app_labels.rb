class AddFieldsToAppDictAndAppLabels < ActiveRecord::Migration
  def change
    add_column :app_labels, :plural_label, :string, :after => 'label'
    add_column :app_label_dictionaries, :plural_name, :string, :after => 'name'
  end
end
