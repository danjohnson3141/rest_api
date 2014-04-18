class RemoveAppLabelPageIdFromAppLabels < ActiveRecord::Migration
  def change
    remove_column :app_labels, :app_label_pages_id, :integer
  end
end
