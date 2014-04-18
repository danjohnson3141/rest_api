require "./db/seed_data"

data = [
  { key: 'username',
    name: 'Corporate Email Address',
    description: 'Login Email Address',
    app_label_page_id: 1
  },
  { key: 'password',
    name: 'Password',
    description: 'Password',
    app_label_page_id: 1
  },
  { key: 'sign_in_button',
    name: 'Sign In',
    description: 'Sign In',
    app_label_page_id: 1
  },
  { key: 'remember_me',
    name: 'Remember Me',
    description: 'Remember Me (Web-app only)',
    app_label_page_id: 1
  },
  { key: 'language',
    name: 'Language Preference',
    description: 'Language Preference',
    app_label_page_id: 1
  },
  { key: 'need_help',
    name: 'Need Help?',
    description: 'Need Help?',
    app_label_page_id: 1
  },
  { key: 'help_options',
    name: 'Help Options',
    description: 'Help Options',
    app_label_page_id: 1
  },
  { key: 'forgot_password',
    name: 'Forgot Password',
    description: 'Forgot Password',
    app_label_page_id: 1
  },
  { key: 'apply_account',
    name: 'Apply for New Account',
    description: 'Apply for New Account',
    app_label_page_id: 1
  },
  { key: 'email_support',
    name: 'Email Support',
    description: 'Email Support',
    app_label_page_id: 1
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 1
  },
  { key: 'access_denied',
    name: 'Wrong username or password',
    description: 'Access Denied',
    app_label_page_id: 1
  },
  { key: 'account_disabled',
    name: 'Your account is no longer active',
    description: 'Account Disabled',
    app_label_page_id: 1
  },
  { key: 'forgot_password',
    name: 'Forgot Password',
    description: 'Forgot Password',
    app_label_page_id: 2
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 2
  },
  { key: 'username',
    name: 'Corporate Email Address',
    description: 'Login Email Address',
    app_label_page_id: 2
  },
  { key: 'continue',
    name: 'Continue',
    description: 'Continue',
    app_label_page_id: 2
  },
  { key: 'success_message',
    name: 'You have been sent an email. Please follow the directions in the email to reset your password.',
    description: 'You have been sent an email. Please follow the directions in the email to reset your password.',
    app_label_page_id: 1
  },
  { key: 'search',
    name: 'Search...',
    description: 'Search...',
    app_label_page_id: 3
  },
  { key: 'app_sponsor',
    name: 'App Sponsors',
    description: 'App Sponsors',
    app_label_page_id: 1
  },
  { key: 'posts',
    name: 'Posts',
    description: 'Posts',
    app_label_page_id: 3
  },
  { key: 'likes',
    name: 'Likes',
    description: 'Likes',
    app_label_page_id: 3
  },
  { key: 'connections',
    name: 'Connections',
    description: 'Connections',
    app_label_page_id: 3
  },
  { key: 'home',
    name: 'Home',
    description: 'Home',
    app_label_page_id: 3
  },
  { key: 'my_groups_header',
    name: 'My Groups',
    description: 'My Groups header',
    app_label_page_id: 3
  },
  { key: 'more_groups',
    name: 'More Groups...',
    description: 'More Groups...',
    app_label_page_id: 3
  },
  { key: 'my_events_header',
    name: 'My Events',
    description: 'My Events header',
    app_label_page_id: 3
  },
  { key: 'todays_event',
    name: 'Today\'s Event - ',
    description: 'Today\'s Event - ',
    app_label_page_id: 3
  },
  { key: 'more_events',
    name: 'More Events...',
    description: 'More Events...',
    app_label_page_id: 3
  },
  { key: 'sponsors_header',
    name: 'Sponsors',
    description: 'Sponsors header',
    app_label_page_id: 3
  },
     { key: 'sponsors',
    name: 'Sponsors',
    description: 'Sponsors',
    app_label_page_id: 3
  },
  { key: 'support_header',
    name: 'Support',
    description: 'Support header',
    app_label_page_id: 3
  },
      { key: 'support',
    name: 'Email Support',
    description: 'Email Support',
    app_label_page_id: 3
  },
  { key: 'logout_header',
    name: 'Logout',
    description: 'Logout_header',
    app_label_page_id: 3
  },
  { key: 'logout',
    name: 'Logout',
    description: 'Logout',
    app_label_page_id: 3
  },
  { key: 'event_feed',
    name: 'Event Feed',
    description: 'Event Feed',
    app_label_page_id: 4
  },
  { key: 'registrants',
    name: 'Registrants',
    description: 'Registrants pre-event',
    app_label_page_id: 4
  },
   { key: 'attendees',
    name: 'Attendees',
    description: 'Attendees post-event',
    app_label_page_id: 4
  },
  { key: 'sessions',
    name: 'Sessions',
    description: 'Sessions',
    app_label_page_id: 4
  },
  { key: 'my_schedule',
    name: 'My Schedule',
    description: 'My Schedule',
    app_label_page_id: 4
  },
  { key: 'sponsors',
    name: 'Sponsors',
    description: 'Sponsors',
    app_label_page_id: 4
  },
  { key: 'speakers',
    name: 'Speakers',
    description: 'Speakers',
    app_label_page_id: 4
  },
  { key: 'my_qr_code',
    name: 'My QR Code',
    description: 'My QR Code',
    app_label_page_id: 4
  },
  { key: 'scanner',
    name: 'Scanner',
    description: 'Scanner',
    app_label_page_id: 4
  },
  { key: 'my_event_notes',
    name: 'My Event Notes',
    description: 'My Event Notes',
    app_label_page_id: 4
  },
  { key: 'leaderboard_rules',
    name: 'Leaderboard Rules',
    description: 'Leaderboard Rules',
    app_label_page_id: 4
  },
  { key: 'leaderboard',
    name: 'Leaderboard',
    description: 'Leaderboard',
    app_label_page_id: 4
  },
  { key: 'my_bookmarks',
    name: 'My Bookmarks',
    description: 'My Bookmarks',
    app_label_page_id: 4
  },
  { key: 'event_info',
    name: 'Event Info',
    description: 'Event Info',
    app_label_page_id: 4
  },
  { key: 'event_evaluation',
    name: 'Event Evaluation',
    description: 'Event Evaluation',
    app_label_page_id: 4
  },
  { key: 'my_feed',
    name: 'My Feed',
    description: 'My Feed',
    app_label_page_id: 5
  },
  { key: 'todays_event',
    name: 'Today\'s Event',
    description: 'Today\'s Event',
    app_label_page_id: 5
  },
  { key: 'featured_content',
    name: 'Featured Content',
    description: 'Featured Content',
    app_label_page_id: 5
  },
  { key: 'like',
    name: 'Like',
    name_plural: 'Likes',
    description: 'Like',
    app_label_page_id: 5
  },
  { key: 'comment',
    name: 'Comment',
    name_plural: 'Comments',
    description: 'Comment',
    app_label_page_id: 5
  },
  { key: 'more',
    name: 'More...',
    description: 'More...',
    app_label_page_id: 5
  },
  { key: 'my_profile',
    name: 'My Profile',
    description: 'My Profile',
    app_label_page_id: 6
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 6
  },
  { key: 'edit',
    name: 'Edit',
    description: 'Edit',
    app_label_page_id: 6
  },
  { key: 'posts',
    name: 'Posts',
    description: 'Posts',
    app_label_page_id: 6
  },
  { key: 'likes',
    name: 'Likes',
    description: 'Likes',
    app_label_page_id: 6
  },
  { key: 'connections',
    name: 'Connections',
    description: 'Connections',
    app_label_page_id: 6
  },
  { key: 'bio',
    name: 'Bio',
    description: 'Bio',
    app_label_page_id: 6
  },
  { key: 'primary_region',
    name: 'Primary Region:',
    description: 'Primary Region',
    app_label_page_id: 6
  },
  { key: 'industry',
    name: 'Industry:',
    description: 'Industry',
    app_label_page_id: 6
  },
  { key: 'events_attended',
    name: 'Events Attended',
    description: 'Events Attended',
    app_label_page_id: 6
  },
  { key: 'more',
    name: 'More...',
    description: 'More...',
    app_label_page_id: 6
  },
  { key: 'groups',
    name: 'Groups',
    description: 'Groups',
    app_label_page_id: 6
  },
  { key: 'my_wall',
    name: 'My Wall',
    description: 'My Wall',
    app_label_page_id: 6
  },
  { key: 'like',
    name: 'Like',
    description: 'Like',
    app_label_page_id: 6
  },
  { key: 'comment',
    name: 'Comment',
    description: 'Comment',
    app_label_page_id: 6
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 7
  },
  { key: 'edit_my_profile',
    name: 'Edit My Profile',
    description: 'Edit My Profile',
    app_label_page_id: 7
  },
  { key: 'done',
    name: 'Done',
    description: 'Done',
    app_label_page_id: 7
  },
  { key: 'edit_picture',
    name: 'Edit Picture',
    description: 'Edit Picture',
    app_label_page_id: 7
  },
  { key: 'corporate_email',
    name: 'Corporate Email (username)',
    description: 'Corporate Email (username)',
    app_label_page_id: 7
  },
      { key: 'first_name',
    name: 'First Name',
    description: 'First Name',
    app_label_page_id: 7
  },
  { key: 'last_name',
    name: 'Last Name',
    description: 'Last Name',
    app_label_page_id: 7
  },
  { key: 'title',
    name: 'Title',
    description: 'Title',
    app_label_page_id: 7
  },
  { key: 'organization',
    name: 'Organization',
    description: 'Organization',
    app_label_page_id: 7
  },
  { key: 'primary_region',
    name: 'Primary Region',
    description: 'Primary Region',
    app_label_page_id: 7
  },
  { key: 'industry',
    name: 'Industry',
    description: 'Industry',
    app_label_page_id: 7
  },
  { key: 'bio',
    name: 'Bio',
    description: 'Bio',
    app_label_page_id: 7
  },
      { key: 'take_photo',
    name: 'Take Photo',
    description: 'Take Photo',
    app_label_page_id: 8
  },
  { key: 'choose_existing',
    name: 'Choose Existing',
    description: 'Choose Existing',
    app_label_page_id: 8
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 8
  },
  { key: 'my_posts',
    name: 'My Posts',
    description: 'My Posts',
    app_label_page_id: 9
  },
      { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 9
  },
  { key: 'my_likes',
    name: 'My Likes',
    description: 'My Likes',
    app_label_page_id: 10
  },
      { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 10
  },
  { key: 'my_connections',
    name: 'My Connections',
    description: 'My Connections page title',
    app_label_page_id: 11
  },
      { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 11
  },
  { key: 'connections',
    name: 'Connections',
    description: 'Connections tab',
    app_label_page_id: 11
  },
      { key: 'connection_requests',
    name: 'Connection Requests',
    description: 'Connection Requests tab',
    app_label_page_id: 11
  },
  { key: 'accept',
    name: 'Accept',
    description: 'Accept button',
    app_label_page_id: 11
  },
      { key: 'ignore',
    name: 'Ignore',
    description: 'Ignore button',
    app_label_page_id: 11
  },
  { key: 'connections_sent',
    name: 'Connection Requests Sent by You',
    description: 'Connection Requests Sent by You',
    app_label_page_id: 11
  },
      { key: 'pending',
    name: 'Pending',
    description: 'Pending button',
    app_label_page_id: 11
  },
  { key: 'my_groups_page',
    name: 'Groups',
    description: 'My Groups page title',
    app_label_page_id: 12
  },
      { key: 'my_groups_tab',
    name: 'My Groups',
    description: 'My Groups tab',
    app_label_page_id: 12
  },
  { key: 'leave_button',
    name: 'Leave',
    description: 'Leave button',
    app_label_page_id: 12
  },
      { key: 'all_groups_tab',
    name: 'All Groups',
    description: 'All Groups tab',
    app_label_page_id: 12
  },
  { key: 'all_groups_page',
    name: 'Groups',
    description: 'All Groups page title',
    app_label_page_id: 13
  },
  { key: 'my_groups_tab',
    name: 'My Groups',
    description: 'My Groups tab',
    app_label_page_id: 13
  },
  { key: 'all_groups_tab',
    name: 'All Groups',
    description: 'All Groups page title',
    app_label_page_id: 13
  },
  { key: 'join_button',
    name: 'Join',
    description: 'Join button',
    app_label_page_id: 13
  },
  { key: 'apply_button',
    name: 'Apply',
    description: 'Apply button',
    app_label_page_id: 13
  },
  { key: 'leave_button',
    name: 'Leave',
    description: 'Leave button',
    app_label_page_id: 13
  },
  { key: 'pending_button',
    name: 'Pending',
    description: 'Pending Button',
    app_label_page_id: 13
  },
  { key: 'hosted',
    name: 'Hosted by:',
    description: 'Hosted by:',
    app_label_page_id: 13
  },
  { key: 'create_group_page',
    name: 'Create Group',
    description: 'Create Group page title',
    app_label_page_id: 14
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 14
  },
  { key: 'save',
    name: 'Save',
    description: 'Save',
    app_label_page_id: 14
  },
  { key: 'group_name',
    name: 'Group Name',
    description: 'Group Name',
    app_label_page_id: 14
  },
  { key: 'group_description',
    name: 'Group Description',
    description: 'Group Description',
    app_label_page_id: 14
  },
  { key: 'group_privacy',
    name: 'Group Privacy (this selection cannot be changed later)',
    description: 'Group Privacy',
    app_label_page_id: 14
  },
  { key: 'public',
    name: 'Public: All users* can see the group, access group content and view group members.',
    description: 'Public Group description',
    app_label_page_id: 14
  },
  { key: 'private',
    name: 'Private: All users* can see the group. Only group members can access group content and view group members.',
    description: 'Private Group description',
    app_label_page_id: 14
  },
  { key: 'secret',
    name: 'Secret: Only group members can see the group, access group content and view group members.',
    description: 'Secret Group description',
    app_label_page_id: 14
  },
  { key: 'users_definition',
    name: '*Users include leaders from all communities Evanta Access serves (IT, security, HR, finance, etc.)',
    description: 'Users definition',
    app_label_page_id: 14
  },
  { key: 'group_name_error',
    name: 'Group Name already exists.',
    description: 'Group Name error message',
    app_label_page_id: 14
  },
  { key: 'group_description_error',
    name: 'Group Description must be between 1 and 500 characters.',
    description: 'Group Description error message',
    app_label_page_id: 14
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 15
  },
  { key: 'save',
    name: 'Save',
    description: 'Save',
    app_label_page_id: 15
  },
  { key: 'feed_tab',
    name: 'Feed',
    description: 'Feed tab',
    app_label_page_id: 15
  },
  { key: 'members_tab',
    name: 'Members',
    description: 'Members tab',
    app_label_page_id: 15
  },
  { key: 'info_tab',
    name: 'Info',
    description: 'Info tab',
    app_label_page_id: 15
  },
  { key: 'sponsor_tab',
    name: 'Sponsor',
    description: 'Sponsor tab',
    app_label_page_id: 15
  },
  { key: 'admin_tab',
    name: 'Admin',
    description: 'Admin tab',
    app_label_page_id: 15
  },
  { key: 'group_name',
    name: 'Group Name',
    description: 'Group Name',
    app_label_page_id: 15
  },
  { key: 'group_description',
    name: 'Group Description',
    description: 'Group Description',
    app_label_page_id: 15
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 16
  },
  { key: 'feed_tab',
    name: 'Feed',
    description: 'Feed tab',
    app_label_page_id: 16
  },
  { key: 'members_tab',
    name: 'Members',
    description: 'Members tab',
    app_label_page_id: 16
  },
  { key: 'info_tab',
    name: 'Info',
    description: 'Info tab',
    app_label_page_id: 16
  },
  { key: 'sponsor_tab',
    name: 'Sponsor',
    description: 'Sponsor tab',
    app_label_page_id: 16
  },
  { key: 'like',
    name: 'Like',
    name_plural: 'Likes',
    description: 'Like',
    app_label_page_id: 16
  },
  { key: 'comment',
    name: 'Comment',
    name_plural: 'Comments',
    description: 'Comment',
    app_label_page_id: 16
  },
  { key: 'apply',
    name: 'Apply',
    description: 'Apply',
    app_label_page_id: 17
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 17
  },
  { key: 'feed_tab',
    name: 'Feed',
    description: 'Feed tab',
    app_label_page_id: 17
  },
  { key: 'members_tab',
    name: 'Members',
    description: 'Members tab',
    app_label_page_id: 17
  },
  { key: 'info_tab',
    name: 'Info',
    description: 'Info tab',
    app_label_page_id: 17
  },
  { key: 'sponsor_tab',
    name: 'Sponsor',
    description: 'Sponsor tab',
    app_label_page_id: 17
  },
  { key: 'admin_tab',
    name: 'Admin',
    description: 'Admin tab',
    app_label_page_id: 17
  },
  { key: 'group_members_private',
    name: 'You must be a member to view private content.',
    description: 'You must be a member to view private content.',
    app_label_page_id: 17
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 18
  },
  { key: 'feed_tab',
    name: 'Feed',
    description: 'Feed tab',
    app_label_page_id: 18
  },
  { key: 'apply',
    name: 'Apply',
    description: 'Apply',
    app_label_page_id: 18
  },
  { key: 'members_tab',
    name: 'Members',
    description: 'Members tab',
    app_label_page_id: 18
  },
  { key: 'info_tab',
    name: 'Info',
    description: 'Info tab',
    app_label_page_id: 18
  },
  { key: 'sponsor_tab',
    name: 'Sponsor',
    description: 'Sponsor tab',
    app_label_page_id: 18
  },
  { key: 'admin_tab',
    name: 'Admin',
    description: 'Admin tab',
    app_label_page_id: 18
  },
  { key: 'join',
    name: 'Join',
    description: 'Join',
    app_label_page_id: 18
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 19
  },
  { key: 'apply',
    name: 'Apply',
    description: 'Apply',
    app_label_page_id: 19
  },
  { key: 'join',
    name: 'Join',
    description: 'Join',
    app_label_page_id: 19
  },
  { key: 'feed_tab',
    name: 'Feed',
    description: 'Feed tab',
    app_label_page_id: 19
  },
  { key: 'members_tab',
    name: 'Members',
    description: 'Members tab',
    app_label_page_id: 19
  },
  { key: 'info_tab',
    name: 'Info',
    description: 'Info tab',
    app_label_page_id: 19
  },
  { key: 'sponsor_tab',
    name: 'Sponsor',
    description: 'Sponsor tab',
    app_label_page_id: 19
  },
  { key: 'admin_tab',
    name: 'Admin',
    description: 'Admin tab',
    app_label_page_id: 19
  },
  { key: 'contacts_header',
    name: 'Contacts',
    description: 'Contacts header',
    app_label_page_id: 19
  },
  { key: 'content_header',
    name: 'Content',
    description: 'Content header',
    app_label_page_id: 19
  },
  { key: 'more',
    name: 'More...',
    description: 'More...',
    app_label_page_id: 19
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 20
  },
  { key: 'feed_tab',
    name: 'Feed',
    description: 'Feed tab',
    app_label_page_id: 20
  },
  { key: 'members_tab',
    name: 'Members',
    description: 'Members tab',
    app_label_page_id: 20
  },
  { key: 'info_tab',
    name: 'Info',
    description: 'Info tab',
    app_label_page_id: 20
  },
  { key: 'sponsors_tab',
    name: 'Sponsors',
    description: 'Sponsors tab',
    app_label_page_id: 20
  },
  { key: 'admin_tab',
    name: 'Admin',
    description: 'Admin tab',
    app_label_page_id: 20
  },
  { key: 'click_instructions',
    name: 'Click the + to add invitees',
    description: 'Click the + to add invitees',
    app_label_page_id: 20
  },
  { key: 'send_invite_button',
    name: 'Send Group Invitation to Above List',
    description: 'Send Group Invitation to Above List',
    app_label_page_id: 20
  },
  { key: 'events_page_title',
    name: 'Events',
    description: 'Events page title',
    app_label_page_id: 21
  },
  { key: 'my_events_tab',
    name: 'My Events',
    description: 'My Events tab',
    app_label_page_id: 21
  },
  { key: 'past_events_tab',
    name: 'All Past Events',
    description: 'All Past Events tab',
    app_label_page_id: 21
  },
  { key: 'upcoming_events_tab',
    name: 'All Upcoming Events',
    description: 'All Upcoming Events tab',
    app_label_page_id: 21
  },
  { key: 'filter_text',
    name: 'Filter by:',
    description: 'Filter by:',
    app_label_page_id: 21
  },
  { key: 'clear_button',
    name: 'Clear',
    description: 'Clear',
    app_label_page_id: 21
  },
  { key: 'registered',
    name: 'Registered',
    description: 'Registered',
    app_label_page_id: 21
  },
  { key: 'invited',
    name: 'Invited',
    description: 'Invited',
    app_label_page_id: 21
  },
  { key: 'attended',
    name: 'Attended',
    description: 'Attended',
    app_label_page_id: 21
  },
  { key: 'following_button',
    name: 'Following',
    description: 'Following button',
    app_label_page_id: 21
  },
  { key: 'follow_button',
    name: 'Follow',
    description: 'Follow button',
    app_label_page_id: 21
  },
  { key: 'todays_event_bar',
    name: 'Today\'s Event',
    description: 'Today\'s Event',
    app_label_page_id: 21
  },
  { key: 'events_page_title',
    name: 'Events',
    description: 'Events page title',
    app_label_page_id: 22
  },
  { key: 'my_events_tab',
    name: 'My Events',
    description: 'My Events tab',
    app_label_page_id: 22
  },
  { key: 'past_events_tab',
    name: 'All Past Events',
    description: 'All Past Events tab',
    app_label_page_id: 22
  },
  { key: 'upcoming_events_tab',
    name: 'All Upcoming Events',
    description: 'All Upcoming Events tab',
    app_label_page_id: 22
  },
  { key: 'todays_event_bar',
    name: 'Today\'s Event',
    description: 'Today\'s Event',
    app_label_page_id: 22
  },
  { key: 'filter_text',
    name: 'Filter by:',
    description: 'Filter by:',
    app_label_page_id: 22
  },
  { key: 'clear_button',
    name: 'Clear',
    description: 'Clear button',
    app_label_page_id: 22
  },
  { key: 'invited',
    name: 'Invited',
    description: 'Invited',
    app_label_page_id: 22
  },
  { key: 'registered',
    name: 'Registered',
    description: 'Registered',
    app_label_page_id: 22
  },
  { key: 'attended',
    name: 'Attended',
    description: 'Attended',
    app_label_page_id: 22
  },
  { key: 'follow_button',
    name: 'Follow',
    description: 'Follow button',
    app_label_page_id: 22
  },
  { key: 'following_button',
    name: 'Following',
    description: 'Following button',
    app_label_page_id: 22
  },
  { key: 'events_page_title',
    name: 'Events',
    description: 'Events page title',
    app_label_page_id: 23
  },
  { key: 'my_events_tab',
    name: 'My Events',
    description: 'My Events tab',
    app_label_page_id: 23
  },
  { key: 'past_events_tab',
    name: 'All Past Events',
    description: 'All Past Events tab',
    app_label_page_id: 23
  },
  { key: 'upcoming_events_tab',
    name: 'All Upcoming Events',
    description: 'All Upcoming Events tab',
    app_label_page_id: 23
  },
  { key: 'todays_event_bar',
    name: 'Today\'s Event',
    description: 'Today\'s Event bar',
    app_label_page_id: 23
  },
  { key: 'filter_text',
    name: 'Filter by:',
    description: 'Filter by:',
    app_label_page_id: 23
  },
  { key: 'clear_button',
    name: 'Clear',
    description: 'Clear button',
    app_label_page_id: 23
  },
  { key: 'invited',
    name: 'Invited',
    description: 'Invited',
    app_label_page_id: 23
  },
  { key: 'registered',
    name: 'Registered',
    description: 'Registered',
    app_label_page_id: 23
  },
  { key: 'attended',
    name: 'Attended',
    description: 'Attended',
    app_label_page_id: 23
  },
  { key: 'follow_button',
    name: 'Follow',
    description: 'Follow button',
    app_label_page_id: 23
  },
  { key: 'following_button',
    name: 'Following',
    description: 'Following button',
    app_label_page_id: 23
  },
  { key: 'event_feed_bar',
    name: 'Event Feed',
    description: 'Event Feed bar',
    app_label_page_id: 24
  },
  { key: 'status_button',
    name: 'Status',
    description: 'Status button',
    app_label_page_id: 24
  },
  { key: 'photo_button',
    name: 'Photo',
    description: 'Photo button',
    app_label_page_id: 24
  },
  { key: 'like',
    name: 'Like',
    name_plural: 'Likes',
    description: 'Like',
    app_label_page_id: 24
  },
  { key: 'comment',
    name: 'Comment',
    name_plural: 'Comments',
    description: 'Comment',
    app_label_page_id: 24
  },
  { key: 'more',
    name: 'More...',
    description: 'More...',
    app_label_page_id: 24
  },
  { key: 'featured_content_bar',
    name: 'Featured Content',
    description: 'Featured Content bar',
    app_label_page_id: 24
  },
  { key: 'messages_page_title',
    name: 'My Messages',
    description: 'My Messages',
    app_label_page_id: 25
  },
  { key: 'delete',
    name: 'Delete',
    description: 'Delete',
    app_label_page_id: 25
  },
  { key: 'no_messages',
    name: 'You have no messages.',
    description: 'You have no messages.',
    app_label_page_id: 25
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 26
  },
  { key: 'send',
    name: 'Send',
    description: 'Send',
    app_label_page_id: 26
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 27
  },
  { key: 'send',
    name: 'Send',
    description: 'Send',
    app_label_page_id: 27
  },
  { key: 'registered',
    name: 'Registered',
    description: 'Registered',
    app_label_page_id:  28
  },
  { key: 'invited',
    name: 'Invited',
    description: 'Invited',
    app_label_page_id:  28
  },
  { key: 'attended',
    name: 'Attended',
    description: 'Attended',
    app_label_page_id:  28
  },
  { key: 'chars_left',
    name: 'characters left',
    description: 'characters left',
    app_label_page_id: 15
  },
  { key: 'no_members',
    name: 'This group has no members.',
    description: 'This group has no members.',
    app_label_page_id: 17
  },
  { key: 'no_groups',
    name: 'You are not a member of any groups.',
    description: 'You are not a member of any groups.',
    app_label_page_id: 12
  },
  { key: 'members',
    name: 'Members',
    description: 'Members',
    app_label_page_id: 12
  },
  { key: 'members',
    name: 'Members',
    description: 'Members',
    app_label_page_id: 13
  },
  { key: 'email_support_header',
    name: 'Email Support',
    description: 'Email Support page header',
    app_label_page_id: 29
  },
  { key: 'cancel',
    name: 'Cancel',
    description: 'Cancel',
    app_label_page_id: 29
  },
  { key: 'submit',
    name: 'Submit',
    description: 'Submit',
    app_label_page_id: 29
  },
  { key: 'your_message',
    name: 'Please enter a message to the support team:',
    description: 'Please enter a message to the support team:',
    app_label_page_id: 29
  },
  { key: 'sponsors_header',
    name: 'Sponsors',
    description: 'Sponsors header',
    app_label_page_id: 30
  },
  { key: 'global_collaboration_partner',
    name: 'Global Collaboration Partner',
    name_plural: 'Global Collaboration Partners',
    description: 'Global Collaboration Partner',
    app_label_page_id: 30
  },
  { key: 'enterprise_partner',
    name: 'Enterprise Partner',
    name_plural: 'Enterprise Partners',
    description: 'Enterprise Partners',
    app_label_page_id: 30
  },
  { key: 'community_sponsor',
    name: 'Community Sponsor',
    description: 'Community Sponsor',
    app_label_page_id: 30
  },
  { key: 'digital_content_development',
    name: 'Digital Content Development Sponsor',
    description: 'Digital Content Development Sponsor',
    app_label_page_id: 30
  },
  { key: 'group_sponsor',
    name: 'Group Sponsor',
    name_plural: 'Group Sponsors',
    description: 'Group Sponsor',
    app_label_page_id: 30
  },
  { key: 'back',
    name: 'Back',
    description: 'Back',
    app_label_page_id: 30
  },
]

SeedData.new('AppLabelDictionary').load(data)
