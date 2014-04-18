class AddFkEventSponsors < ActiveRecord::Migration
  def up
    change_table :event_sponsors do |t|
      t.foreign_key :events
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :event_sponsors do |t|
      t.remove_foreign_key :events
    end
    remove_foreign_key(:event_sponsors, name: 'event_sponsors_created_by_fk')
    remove_foreign_key(:event_sponsors, name: 'event_sponsors_updated_by_fk')
  end
end
