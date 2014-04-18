class RemoveLanguageFromLabels < ActiveRecord::Migration
  def change
    execute "ALTER TABLE `app_labels` DROP FOREIGN KEY `app_labels_app_language_id_fk`"
    remove_column :app_labels, :app_language_id, :integer
  end
end
