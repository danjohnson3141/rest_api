class ChangeSponsorTypeToReference < ActiveRecord::Migration
  def change
    remove_column :app_sponsors, :sponsor_type
    add_reference :app_sponsors, :sponsor_type, :after => :url
    add_reference :event_sponsors, :sponsor_type, :after => :url
    # change_column :app_sponsors, :sponsor_type_id, :null => false
    # change_column :event_sponsors, :sponsor_type_id, :null => false
    add_foreign_key :app_sponsors, :sponsor_types
    add_foreign_key :event_sponsors, :sponsor_types
  end
end
