class RenameLanguageAndLabelOptions < ActiveRecord::Migration
  def up
    rename_column :app_labels, :app_label_language_id, :app_language_id
    rename_column :app_labels, :app_label_option_id, :app_label_dictionary_id
  end
  def down
    rename_column :app_labels, :app_language_id, :app_label_language_id
    rename_column :app_labels, :app_label_dictionary_id, :app_label_option_id
  end
end
