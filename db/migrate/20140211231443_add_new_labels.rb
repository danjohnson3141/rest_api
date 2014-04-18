class AddNewLabels < ActiveRecord::Migration
  def change
    return # we don't want to seed via migrations like this anymore.
    return if Rails.env == "test"

    puts 'Seeding app_label_pages table...'
      AppLabelPage.create([
      { id: 28,
        name: 'registration_status',
        description: 'Labels for various Reg Statuses',
        auth_required: 1 }
      ])
    
    puts 'Seeding app_label_dictionaries table...'
    AppLabelDictionary.create([
    {
      #event_registration_statuses_id = 1
      key: 'pending',
      name: 'Pending',
      description: 'Pending',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 2
      key: 'approved',
      name: 'Approved',
      description: 'Approved',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 3
      key: 'declined',
      name: 'Declined',
      description: 'Declined',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 4
      key: 'waitlist',
      name: 'Waitlist',
      description: 'Waitlist',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 5
      key: 'approved_sponsor',
      name: 'Approved Sponsor',
      description: 'Approved Sponsor',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 6
      key: 'registered',
      name: 'Registered',
      description: 'Registered',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 7
      key: 'canceled',
      name: 'Canceled',
      description: 'Canceled',
      app_label_page_id:  28
    },
    {
      #event_registration_statuses_id = 8
      key: 'eligibility_confirmed',
      name: 'Eligibility Confirmed',
      description: 'Eligibility Confirmed',
      app_label_page_id:  28
    },
    {
      key: 'invited',
      name: 'Invited',
      description: 'Invited',
      app_label_page_id:  28
    },
    {
      key: 'attended',
      name: 'Attended',
      description: 'Attended',
      app_label_page_id:  28
    }
    ])

    puts 'Seeding app_labels table from app_label_dictionaries...'
    app_label_dictionaries = AppLabelDictionary.where(app_label_page_id: 28)

    app_label_dictionaries.each do |app_label_dictionary|
      app_label = {
        app_label_dictionary_id: app_label_dictionary['id'],
        label: app_label_dictionary['name'],
        label_plural: app_label_dictionary['name_plural']
      }
      AppLabel.create!(app_label)
    end

  end
end
