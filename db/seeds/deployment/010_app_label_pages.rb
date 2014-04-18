require "./db/seed_data"

data = [
  { id: 1,
    name: 'login',
    description: 'Initial Login Page',
    auth_required: 0
  },
  { id: 2,
    name: 'forgot_password',
    description: 'Forgot Password Page',
    auth_required: 0
  },
  { id: 3,
    name: 'leftmenu',
    description: 'Main App (left) menu',
    auth_required: 1
  },
  { id: 4,
    name: 'rightmenu',
    description: 'Event (right) menu',
    auth_required: 1
  },
  { id: 5,
    name: 'my_feed',
    description: 'User\'s feed',
    auth_required: 1
  },
  { id: 6,
    name: 'my_profile',
    description: 'User\'s own profile',
    auth_required: 1
  },
  { id: 7,
    name: 'edit_profile',
    description: 'Where user edits their profile',
    auth_required: 1
  },
  { id: 8,
    name: 'edit_thumbnail',
    description: 'Edit your photo',
    auth_required: 1
  },
  { id: 9,
    name: 'my_posts',
    description: 'List of user\'s Posts',
    auth_required: 1
  },
  { id: 10,
    name: 'my_likes',
    description: 'List of user\'s Likes',
    auth_required: 1
  },
  { id: 11,
    name: 'my_connections',
    description: 'List of user\'s Connections',
    auth_required: 1
  },
  { id: 12,
    name: 'my_groups',
    description: 'List of Groups user is a member of',
    auth_required: 1
  },
  { id: 13,
    name: 'all_groups',
    description: 'List of all visible groups to user',
    auth_required: 1
  },
  { id: 14,
    name: 'create_group',
    description: 'Create a group form',
    auth_required: 1
  },
  { id: 15,
    name: 'edit_group',
    description: 'Edit a group form',
    auth_required: 1
  },
  { id: 16,
    name: 'group_feed',
    description: 'Group feed page',
    auth_required: 1
  },
  { id: 17,
    name: 'group_members',
    description: 'List of all group members',
    auth_required: 1
  },
  { id: 18,
    name: 'group_info',
    description: 'Group information page',
    auth_required: 1
  },
  { id: 19,
    name: 'group_sponsor',
    description: 'Group sponsor page',
    auth_required: 1
  },
  { id: 20,
    name: 'invite_to_group',
    description: 'Page to invite users to a group',
    auth_required: 1
  },
  { id: 21,
    name: 'my_events',
    description: 'List of Events user is invited, registered or attending or following',
    auth_required: 1
  },
  { id: 22,
    name: 'past_events',
    description: 'List of all events older than now',
    auth_required: 1
  },
  { id: 23,
    name: 'upcoming_events',
    description: 'List of all events in the future',
    auth_required: 1
  },
  { id: 24,
    name: 'event_feed',
    description: 'Event feed page',
    auth_required: 1
  },
  { id: 25,
    name: 'messages_inbox',
    description: 'Message conversations list page',
    auth_required: 1
  },
  { id: 26,
    name: 'message_view',
    description: 'View of individual conversation thread',
    auth_required: 1
  },
  { id: 27,
    name: 'message_compose',
    description: 'Compose new message form',
    auth_required: 1
  },
  { id: 28,
    name: 'registration_status',
    description: 'Labels for various Reg Statuses',
    auth_required: 1
  },
  { id: 29,
    name: 'contact_support_unauth',
    description: 'Unauthenticated Contact Support form',
    auth_required: 0
  },
  { id: 30,
    name: 'app_sponsor',
    description: 'App Sponsor page',
    auth_required: 1
  },
]

SeedData.new('AppLabelPage').load(data)
