class AddSponsorToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :sponsor, index: true, after: "group_id"
    add_foreign_key :posts, :sponsors
  end
end
