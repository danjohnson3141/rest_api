class AddEventToAppLabels < ActiveRecord::Migration
  def change
    add_reference :app_labels, :event, index: true, after: :plural
  end
end
