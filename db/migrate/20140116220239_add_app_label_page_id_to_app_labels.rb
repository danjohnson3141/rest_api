class AddAppLabelPageIdToAppLabels < ActiveRecord::Migration
  def change
    rename_column :app_labels, :singular, :label
    add_reference :app_labels, :app_label_pages, index: true, after: :label
  end
end
