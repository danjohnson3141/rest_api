class RenameAppSponsors < ActiveRecord::Migration
  def change
    rename_table :app_sponsors, :sponsors
    add_reference :sponsors, :event, index: true, after: :url
    add_reference :sponsors, :group, index: true, after: :event_id
    rename_column :sponsors, :primary_app_sponsor, :splash_sponosor
  end
end
