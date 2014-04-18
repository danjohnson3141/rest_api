class AddFkEvents < ActiveRecord::Migration
  def up
    change_table :events do |t|
      t.foreign_key :groups
      t.foreign_key :countries
      t.foreign_key :timezones
      t.foreign_key :users, column: 'created_by'
      t.foreign_key :users, column: 'updated_by'
    end
  end
  def down
  	change_table :events do |t|
      t.remove_foreign_key :groups
      t.remove_foreign_key :countries
      t.remove_foreign_key :timezones
    end
    remove_foreign_key(:events, name: 'events_created_by_fk')
    remove_foreign_key(:events, name: 'events_updated_by_fk')
  end
end
