class UpdateRegistrationStatuses < ActiveRecord::Migration
  # registeration.destroy_all
  # remove old dictionary, labels, and translations
  # remove desc, name
  # add key replaces name
  # add app_label_dict_id with fk
  # replace reg_stat_id in event_users
  # 

  def change

    # Clear out previous seed data
    EventUser.delete_all
    ActiveRecord::Base.connection.execute("ALTER TABLE #{EventUser.table_name} AUTO_INCREMENT = 1")


    # Clear out previous seed data
    EventRegistrationStatus.delete_all
    ActiveRecord::Base.connection.execute("ALTER TABLE #{EventRegistrationStatus.table_name} AUTO_INCREMENT = 1")


    # Update to new table structure
    remove_column :event_registration_statuses, :description
    rename_column :event_registration_statuses, :name, :key
    add_column :event_registration_statuses, :app_label_dictionary_id, :integer, null: false, after: "key"
    add_foreign_key :event_registration_statuses, :app_label_dictionaries

    if Rails.env != "test"
      
      # remove old label data from dictionary, labels, and translations
      ["pending","approved","declined","waitlist","approved_sponsor","canceled","eligibility_confirmed"].each do |key|
        remove_old_label_data(key)
      end

      # load new EventRegistrationStatus
      load "db/seeds/deployment/030_event_registration_statuses.rb"

      # Add back the event_users
      load "db/seeds/development/045_event_users.rb"
    end
  end


  def remove_old_label_data(key)
    ald = AppLabelDictionary.where(key: key).first
    if !ald.nil?
      app_labels = AppLabel.where(app_label_dictionary_id: ald.id)

      app_labels.each do |app_label|
        ActiveRecord::Base.connection.execute("DELETE FROM `app_label_translations` WHERE `app_label_id` IN ('#{app_label.id}');")
      end

      app_labels.delete_all
      ald.delete
    end
  end


end
