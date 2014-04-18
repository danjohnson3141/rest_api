class RemovePluralFromAppLabels < ActiveRecord::Migration
  def change
    remove_column :app_labels, :plural, :integer
  end
end
