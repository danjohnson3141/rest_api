class AddEventToPosts < ActiveRecord::Migration
  def change
    add_reference :posts, :event, index: true, after: "view_count" 
    add_foreign_key :posts, :events
  end
end
