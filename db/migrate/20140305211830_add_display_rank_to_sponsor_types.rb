class AddDisplayRankToSponsorTypes < ActiveRecord::Migration
  def change
    add_column :sponsor_types, :display_rank, :integer, after: "description", null: false
  end
end