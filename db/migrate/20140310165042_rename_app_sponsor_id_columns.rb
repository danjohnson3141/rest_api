class RenameAppSponsorIdColumns < ActiveRecord::Migration
  def change

    # Banner ads
    remove_foreign_key :banner_ads, name: 'banner_ads_app_sponsor_id_fk'
    remove_foreign_key :banner_ads, name: 'banner_ads_event_id_fk'
    remove_foreign_key :banner_ads, name: 'banner_ads_event_sponsor_id_fk'
    remove_foreign_key :banner_ads, name: 'banner_ads_group_id_fk'
    rename_column :banner_ads, :app_sponsor_id, :sponsor_id
    remove_column :banner_ads, :event_sponsor_id
    remove_column :banner_ads, :group_id
    remove_column :banner_ads, :event_id
    add_foreign_key :banner_ads, :sponsors

    # Groups
    remove_foreign_key :groups, name: 'groups_app_sponsor_id_fk'
    remove_column :groups, :app_sponsor_id

    # sponsor_attachments
    remove_foreign_key :sponsor_attachments, name: 'sponsor_attachments_event_sponsor_id_fk'
    rename_column :sponsor_attachments, :event_sponsor_id, :sponsor_id
    add_foreign_key :sponsor_attachments, :sponsors
    
    # event_bookmarks
    remove_foreign_key :event_bookmarks, name: 'user_event_bookmarks_event_sponsor_id_fk'

    rename_column :event_bookmarks, :event_sponsor_id, :sponsor_id
    add_foreign_key :event_bookmarks, :sponsors

    # event_notes
    remove_foreign_key :event_notes, name: 'user_event_notes_event_sponsor_id_fk'
    rename_column :event_notes, :event_sponsor_id, :sponsor_id
    add_foreign_key :event_notes, :sponsors

    # event_sessions
    remove_foreign_key :event_sessions, name: 'event_sessions_event_sponsor_id_fk'
    rename_column :event_sessions, :event_sponsor_id, :sponsor_id
    add_foreign_key :event_sessions, :sponsors
    
    # event_users
    remove_foreign_key :event_users, name: 'event_users_event_sponsor_id_fk'
    rename_column :event_users, :event_sponsor_id, :sponsor_id
    add_foreign_key :event_users, :sponsors
    
    # Do me last or bad things will happen!
    drop_table :event_sponsors
  end
end
