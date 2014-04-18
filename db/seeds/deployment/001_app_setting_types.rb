require "./db/seed_data"

data = [
  { :id => 1,
    :name => 'App',
    :description => 'Used for app level settings'
  },
  { :id => 2,
    :name => 'Event',
    :description => 'Used for event level settings'
  },
  { :id => 3,
    :name => 'Group',
    :description => 'Used for group level settings'
  },
  { :id => 4,
    :name => 'UserRole',
    :description => 'Used for user-role settings, each one able to have a different set of settings'
  },
  { :id => 5,
    :name => 'User',
    :description => 'Used for user settings, that a user will set themselves'
  }
]

SeedData.new('AppSettingType').load(data)