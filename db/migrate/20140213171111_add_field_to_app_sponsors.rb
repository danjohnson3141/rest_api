class AddFieldToAppSponsors < ActiveRecord::Migration
  def change
  	add_column :app_sponsors, :primary_app_sponsor, :boolean, after: "sponsor_type_id", default: 0, null: false, index: true
  end
end
