class UpdateSponsorSponsorType < ActiveRecord::Migration
  def change
    change_column :sponsors, :sponsor_type_id, :integer, null: false
  end
end
