require "./db/seed_data"

data = [
  { id: 1, name: %Q(Main – Turn off Sponsors section & App banner ads), description: "App Sponsor", app_setting_type_id: 1 },
  { id: 2, name: %Q(Main – Turn off Group nav section (but core group functionality continues)), description: "Group", app_setting_type_id: 1 },
  { id: 3, name: %Q(Main – Turn off Group nav section (but core group functionality continues)), description: "Group", app_setting_type_id: 4 },
  { id: 4, name: %Q(Hide Public/Private groups from non-members (you can always see those you are a part of)), description: "Group", app_setting_type_id: 1 },
  { id: 5, name: %Q(Hide Public/Private groups from non-members (you can always see those you are a part of)), description: "Group", app_setting_type_id: 4 },
  { id: 6, name: %Q(Users cannot Join groups), description: "Group", app_setting_type_id: 1 },
  { id: 7, name: %Q(Users cannot Join groups), description: "Group", app_setting_type_id: 4 },
  { id: 8, name: %Q(Users cannot create group), description: "Group", app_setting_type_id: 1 },
  { id: 9, name: %Q(Users cannot create group), description: "Group", app_setting_type_id: 4 },
  { id: 10, name: %Q(Users cannot leave groups), description: "Group", app_setting_type_id: 1 },
  { id: 11, name: %Q(Users cannot leave groups), description: "Group", app_setting_type_id: 3 },
  { id: 12, name: %Q(Users cannot leave groups), description: "Group", app_setting_type_id: 4 },
  { id: 13, name: %Q(Hide Lists (Event Registrants/Attendees or Group member)), description: "Member List", app_setting_type_id: 1 },
  { id: 14, name: %Q(Hide Event Registrant/Attendees list), description: "Member List", app_setting_type_id: 2 },
  { id: 15, name: %Q(Hide Group member list), description: "Member List", app_setting_type_id: 3 },
  { id: 16, name: %Q(Hide Lists (Event Registrants/Attendees or Group member)), description: "Member List", app_setting_type_id: 4 },
  { id: 17, name: %Q(Hide user on attendee/member lists), description: "Member List", app_setting_type_id: 4 },
  { id: 18, name: %Q(Hide user on attendee/member lists), description: "Member List", app_setting_type_id: 5 },
  { id: 19, name: %Q(Keep "Registered" list forever (Instead of switching to show "Attendees" on first day of event)), description: "Member List", app_setting_type_id: 1 },
  { id: 20, name: %Q(Keep "Registered" list forever (Instead of switching to show "Attendees" on first day of event)), description: "Member List", app_setting_type_id: 2 },
  { id: 21, name: %Q(Disable user Profile (if disabled, user is read-only, invisible)), description: "Profile", app_setting_type_id: 1 },
  { id: 22, name: %Q(Disable user Profile (if disabled, user is read-only, invisible)), description: "Profile", app_setting_type_id: 4 },
  { id: 23, name: %Q(User cannot View profiles of other Users), description: "Profile", app_setting_type_id: 1 },
  { id: 24, name: %Q(User cannot View profiles of other Users), description: "Profile", app_setting_type_id: 4 },
  { id: 25, name: %Q(User cannot Edit profile), description: "Profile", app_setting_type_id: 1 },
  { id: 26, name: %Q(User cannot Edit profile), description: "Profile", app_setting_type_id: 4 },
  { id: 27, name: %Q(Users – Hide Summary count of Posts from user profile view/left nav), description: "Profile", app_setting_type_id: 1 },
  { id: 28, name: %Q(Users – Hide Summary count of Posts from user profile view/left nav), description: "Profile", app_setting_type_id: 4 },
  { id: 29, name: %Q(Users – Hide Summary count of Posts from user profile view/left nav), description: "Profile", app_setting_type_id: 5 },
  { id: 30, name: %Q(Users – Hide Summary count of Likes from user profile view/left nav), description: "Profile", app_setting_type_id: 1 },
  { id: 31, name: %Q(Users – Hide Summary count of Likes from user profile view/left nav), description: "Profile", app_setting_type_id: 4 },
  { id: 32, name: %Q(Users – Hide Summary count of Likes from user profile view/left nav), description: "Profile", app_setting_type_id: 5 },
  { id: 33, name: %Q(Users – Hide Summary count of Connections from user profile view/left nav), description: "Profile", app_setting_type_id: 1 },
  { id: 34, name: %Q(Users – Hide Summary count of Connections from user profile view/left nav), description: "Profile", app_setting_type_id: 4 },
  { id: 35, name: %Q(Users – Hide Summary count of Connections from user profile view/left nav), description: "Profile", app_setting_type_id: 5 },
  { id: 36, name: %Q(User has no wall), description: "Wall", app_setting_type_id: 1 },
  { id: 37, name: %Q(User has no wall), description: "Wall", app_setting_type_id: 4 },
  { id: 38, name: %Q(User's connections cannot see Wall (Recent Activity/Posts/Comments/Likes)), description: "Wall", app_setting_type_id: 5 },
  { id: 39, name: %Q(User's connections cannot write on wall), description: "Wall", app_setting_type_id: 5 },
  { id: 40, name: %Q(Do not Post to User's wall when they update their Title/Organization), description: "Wall", app_setting_type_id: 5 },
  { id: 41, name: %Q(Main – Disable Private Messages), description: "Message", app_setting_type_id: 1 },
  { id: 42, name: %Q(Main – Disable Private Messages), description: "Message", app_setting_type_id: 4 },
  { id: 43, name: %Q(User's cannot Send Private Messages to other Users), description: "Message", app_setting_type_id: 4 },
  { id: 44, name: %Q(User's cannot Receive Private Messages), description: "Message", app_setting_type_id: 4 },
  { id: 45, name: %Q(Block My Connections from sending me private messages), description: "Message", app_setting_type_id: 5 },
  { id: 46, name: %Q(Block members from sending me private messages), description: "Message", app_setting_type_id: 5 },
  { id: 47, name: %Q(Users cannot make Connections), description: "Connection", app_setting_type_id: 1 },
  { id: 48, name: %Q(Users cannot make Connections), description: "Connection", app_setting_type_id: 4 },
  { id: 49, name: %Q(Can connect only on event day* (or lock to only QR code and no ability to connect otherwise) one-way lockdown), description: "Connection", app_setting_type_id: 4 },
  { id: 50, name: %Q(Block members from requesting to add me as a connection), description: "Connection", app_setting_type_id: 5 },
  { id: 51, name: %Q(Block members from seeing my connections), description: "Connection", app_setting_type_id: 5 },
  { id: 52, name: %Q(User cannot @Mention in Posts/Comments), description: "@Mention", app_setting_type_id: 1 },
  { id: 53, name: %Q(User cannot @Mention in Posts/Comments), description: "@Mention", app_setting_type_id: 2 },
  { id: 54, name: %Q(User cannot @Mention in Posts/Comments), description: "@Mention", app_setting_type_id: 3 },
  { id: 55, name: %Q(User cannot @Mention in Posts/Comments), description: "@Mention", app_setting_type_id: 4 },
  { id: 56, name: %Q(Users cannot @Mention me in Posts/Comments), description: "@Mention", app_setting_type_id: 5 },
  { id: 57, name: %Q(Main – Turn off Notifications (store in table no matter what, unless off completely) ??), description: "Notification", app_setting_type_id: 1 },
  { id: 58, name: %Q(Main – Turn off Notifications (store in table no matter what, unless off completely) ??), description: "Notification", app_setting_type_id: 4 },
  { id: 59, name: %Q(Network application is not required (Only signup form)), description: "Security", app_setting_type_id: 1 },
  { id: 60, name: %Q(Main – Hide Support link (pre-auth & left nav)), description: "Support", app_setting_type_id: 1 },
  { id: 61, name: %Q(Main – Disable Search), description: "Search", app_setting_type_id: 1 },
  { id: 62, name: %Q(Main – Disable Search), description: "Search", app_setting_type_id: 3 },
  { id: 63, name: %Q(Main – Disable Search), description: "Search", app_setting_type_id: 4 },
  { id: 64, name: %Q(User cannot search people), description: "Search", app_setting_type_id: 1 },
  { id: 65, name: %Q(User cannot search people), description: "Search", app_setting_type_id: 3 },
  { id: 66, name: %Q(User cannot search people), description: "Search", app_setting_type_id: 4 },
  { id: 67, name: %Q(User cannot search content), description: "Search", app_setting_type_id: 1 },
  { id: 68, name: %Q(User cannot search content), description: "Search", app_setting_type_id: 3 },
  { id: 69, name: %Q(User cannot search content), description: "Search", app_setting_type_id: 4 },
  { id: 70, name: %Q(User cannot search groups/events), description: "Search", app_setting_type_id: 1 },
  { id: 71, name: %Q(User cannot search groups/events), description: "Search", app_setting_type_id: 3 },
  { id: 72, name: %Q(User cannot search groups/events), description: "Search", app_setting_type_id: 4 },
  { id: 73, name: %Q(User cannot Create a Post), description: "Post", app_setting_type_id: 1 },
  { id: 74, name: %Q(User cannot Create a Post), description: "Post", app_setting_type_id: 2 },
  { id: 75, name: %Q(User cannot Create a Post), description: "Post", app_setting_type_id: 3 },
  { id: 76, name: %Q(User cannot Create a Post), description: "Post", app_setting_type_id: 4 },
  { id: 77, name: %Q(User cannot post articles (upgraded version of a post - is blogger)), description: "Post", app_setting_type_id: 1 },
  { id: 78, name: %Q(User cannot post articles (upgraded version of a post - is blogger)), description: "Post", app_setting_type_id: 4 },
  { id: 79, name: %Q(Users cannot add attachments/photos), description: "Post", app_setting_type_id: 1 },
  { id: 80, name: %Q(Users cannot add attachments/photos), description: "Post", app_setting_type_id: 2 },
  { id: 81, name: %Q(Users cannot add attachments/photos), description: "Post", app_setting_type_id: 3 },
  { id: 82, name: %Q(Users cannot add attachments/photos), description: "Post", app_setting_type_id: 4 },
  { id: 83, name: %Q(Users – cannot Edit Posts), description: "Post", app_setting_type_id: 1 },
  { id: 84, name: %Q(Users – cannot Edit Posts), description: "Post", app_setting_type_id: 4 },
  { id: 85, name: %Q(Hide warning when user edits post), description: "Post", app_setting_type_id: 1 },
  { id: 86, name: %Q(Hide warning when user edits post), description: "Post", app_setting_type_id: 4 },
  { id: 87, name: %Q(UNUSED - Show warning when a user edits a post), description: "Post", app_setting_type_id: 1 },
  { id: 88, name: %Q(UNUSED - Show warning when a user edits a post), description: "Post", app_setting_type_id: 4 },
  { id: 89, name: %Q(Users – cannot Delete their own Posts), description: "Post", app_setting_type_id: 1 },
  { id: 90, name: %Q(Users – cannot Delete their own Posts), description: "Post", app_setting_type_id: 4 },
  { id: 91, name: %Q(Hide warning when a user deletes a post), description: "Post", app_setting_type_id: 1 },
  { id: 92, name: %Q(Hide warning when a user deletes a post), description: "Post", app_setting_type_id: 4 },
  { id: 93, name: %Q(UNUSED - Show warning when a user deletes a post), description: "Post", app_setting_type_id: 1 },
  { id: 94, name: %Q(UNUSED - Show warning when a user deletes a post), description: "Post", app_setting_type_id: 4 },
  { id: 95, name: %Q(Users cannot Comment (Post/Session)), description: "Comment", app_setting_type_id: 1 },
  { id: 96, name: %Q(Users cannot Comment (Post/Session)), description: "Comment", app_setting_type_id: 2 },
  { id: 97, name: %Q(Users cannot Comment (Post/Session)), description: "Comment", app_setting_type_id: 3 },
  { id: 98, name: %Q(Users cannot Comment (Post/Session)), description: "Comment", app_setting_type_id: 4 },
  { id: 99, name: %Q(UNUSED - Users cannot add attachments/photos to a comment), description: "Comment", app_setting_type_id: 1 },
  { id: 100, name: %Q(UNUSED - Users cannot add attachments/photos to a comment), description: "Comment", app_setting_type_id: 2 },
  { id: 101, name: %Q(UNUSED - Users cannot add attachments/photos to a comment), description: "Comment", app_setting_type_id: 3 },
  { id: 102, name: %Q(UNUSED - Users cannot add attachments/photos to a comment), description: "Comment", app_setting_type_id: 4 },
  { id: 103, name: %Q(Users – cannot Edit/Delete their comments), description: "Comment", app_setting_type_id: 1 },
  { id: 104, name: %Q(Users – cannot Edit/Delete their comments), description: "Comment", app_setting_type_id: 4 },
  { id: 105, name: %Q(UNUSED - Users – cannot Delete their comments), description: "Comment", app_setting_type_id: 1 },
  { id: 106, name: %Q(UNUSED - Users – cannot Delete their comments), description: "Comment", app_setting_type_id: 4 },
  { id: 107, name: %Q(Hide warning when user deletes their comment), description: "Comment", app_setting_type_id: 1 },
  { id: 108, name: %Q(Hide warning when user deletes their comment), description: "Comment", app_setting_type_id: 4 },
  { id: 109, name: %Q(Users cannot Like (Post/Session)), description: "Like", app_setting_type_id: 1 },
  { id: 110, name: %Q(Users cannot Like (Post/Session)), description: "Like", app_setting_type_id: 2 },
  { id: 111, name: %Q(Users cannot Like (Post/Session)), description: "Like", app_setting_type_id: 3 },
  { id: 112, name: %Q(Users cannot Like (Post/Session)), description: "Like", app_setting_type_id: 4 },
  { id: 113, name: %Q(User cannot view a Post's Likes list), description: "Like", app_setting_type_id: 1 },
  { id: 114, name: %Q(User cannot view a Post's Likes list), description: "Like", app_setting_type_id: 4 },
  { id: 115, name: %Q(Users cannot view attachments (Media) [Posts, profiles, sponsor org pages, Comments]), description: "Media", app_setting_type_id: 4 },
  { id: 116, name: %Q(User does not want to receive the weekly newsletter), description: "Email", app_setting_type_id: 4 },
  { id: 117, name: %Q(User does not want to receive the weekly newsletter), description: "Email", app_setting_type_id: 5 },
  { id: 118, name: %Q(User does not want to receive weekly feed digest), description: "Email", app_setting_type_id: 4 },
  { id: 119, name: %Q(User does not want to receive weekly feed digest), description: "Email", app_setting_type_id: 5 },
  { id: 120, name: %Q(User does not want to receive daily feed digest (content & notifications)), description: "Email", app_setting_type_id: 4 },
  { id: 121, name: %Q(User does not want to receive daily feed digest (content & notifications)), description: "Email", app_setting_type_id: 5 },
  { id: 122, name: %Q(Email me when I receive a new connection request (in digest so default No)), description: "Email", app_setting_type_id: 5 },
  { id: 123, name: %Q(Email me when I receive a new Private Message (in digest so default No)), description: "Email", app_setting_type_id: 5 },
  { id: 124, name: %Q(Email me when Requests to join my private group(s) (in digest so default No)), description: "Email", app_setting_type_id: 5 },
  { id: 125, name: %Q(Main – Disable Events section), description: "Event", app_setting_type_id: 1 },
  { id: 126, name: %Q(Main – Disable Events section), description: "Event", app_setting_type_id: 4 },
  { id: 127, name: %Q(Disable Event splash page (sponsor or not)), description: "Event", app_setting_type_id: 2 },
  { id: 128, name: %Q(Users cannot Follow Events), description: "Event", app_setting_type_id: 1 },
  { id: 129, name: %Q(Combine Past & Upcoming Events), description: "Event", app_setting_type_id: 1 },
  { id: 130, name: %Q(Block members from seeing events I'm registered for or have attended in the past), description: "Event", app_setting_type_id: 5 },
  { id: 131, name: %Q(Event - Hide Today's Event Callout), description: "Event", app_setting_type_id: 1 },
  { id: 132, name: %Q(Event - Hide Today's Event Callout), description: "Event", app_setting_type_id: 2 },
  { id: 133, name: %Q(Disable Event - Info), description: "Event", app_setting_type_id: 1 },
  { id: 134, name: %Q(Disable Event - Info), description: "Event", app_setting_type_id: 2 },
  { id: 135, name: %Q(Users cannot view Events they are not a part of (or have event appear as link)), description: "Event", app_setting_type_id: 1 },
  { id: 136, name: %Q(Users cannot view Events they are not a part of (or have event appear as link)), description: "Event", app_setting_type_id: 4 },
  { id: 137, name: %Q(UNUSED - Hide Event – Sponsors), description: "Event Sponsor", app_setting_type_id: 1 },
  { id: 138, name: %Q(UNUSED - Hide Event – Sponsors), description: "Event Sponsor", app_setting_type_id: 2 },
  { id: 139, name: %Q(UNUSED - Hide Event – Sponsors), description: "Event Sponsor", app_setting_type_id: 4 },
  { id: 140, name: %Q(UNUSED - Hide Event – Sessions), description: "Session", app_setting_type_id: 1 },
  { id: 141, name: %Q(UNUSED - Hide Event – Sessions), description: "Session", app_setting_type_id: 2 },
  { id: 142, name: %Q(UNUSED - Hide Event – Sessions), description: "Session", app_setting_type_id: 4 },
  { id: 143, name: %Q(UNUSED - Hide Event – Speakers), description: "Speaker", app_setting_type_id: 1 },
  { id: 144, name: %Q(UNUSED - Hide Event – Speakers), description: "Speaker", app_setting_type_id: 2 },
  { id: 145, name: %Q(UNUSED - Hide Event – Speakers), description: "Speaker", app_setting_type_id: 4 },
  { id: 146, name: %Q(Disable Event – Notes), description: "Notes", app_setting_type_id: 1 },
  { id: 147, name: %Q(Disable Event – Notes), description: "Notes", app_setting_type_id: 2 },
  { id: 148, name: %Q(Disable Event – Notes), description: "Notes", app_setting_type_id: 4 },
  { id: 149, name: %Q(Disable Event – Bookmarks), description: "Bookmark", app_setting_type_id: 1 },
  { id: 150, name: %Q(Disable Event – Bookmarks), description: "Bookmark", app_setting_type_id: 2 },
  { id: 151, name: %Q(Disable Event – Bookmarks), description: "Bookmark", app_setting_type_id: 4 },
  { id: 152, name: %Q(Disable Event - Evals), description: "Evaluation", app_setting_type_id: 1 },
  { id: 153, name: %Q(Disable Event - Evals), description: "Evaluation", app_setting_type_id: 2 },
  { id: 154, name: %Q(Disable Event - Session Evals), description: "Evaluation", app_setting_type_id: 1 },
  { id: 155, name: %Q(Disable Event - Session Evals), description: "Evaluation", app_setting_type_id: 2 },
  { id: 156, name: %Q(Users cannot take session Evaluation), description: "Evaluation", app_setting_type_id: 4 },
  { id: 157, name: %Q(Users cannot take Event Evaluation(s)), description: "Evaluation", app_setting_type_id: 4 },
  { id: 158, name: %Q(Hide Event – Leaderboard), description: "Leaderboard", app_setting_type_id: 1 },
  { id: 159, name: %Q(Hide Event – Leaderboard), description: "Leaderboard", app_setting_type_id: 2 },
  { id: 160, name: %Q(Hide Event – Leaderboard), description: "Leaderboard", app_setting_type_id: 4 },
  { id: 161, name: %Q(Show Leaderboard Point counts), description: "Leaderboard", app_setting_type_id: 1 },
  { id: 162, name: %Q(Show Leaderboard Point counts), description: "Leaderboard", app_setting_type_id: 2 },
  { id: 163, name: %Q(Show Leaderboard Point counts), description: "Leaderboard", app_setting_type_id: 4 },
  { id: 164, name: %Q(Users cannot participate in Leaderboard), description: "Leaderboard", app_setting_type_id: 4 },
  { id: 165, name: %Q(Hide Leaderboard Ranks w/o points), description: "Leaderboard", app_setting_type_id: 2 },
  { id: 166, name: %Q(Hide Leaderboard Ranks w/o points), description: "Leaderboard", app_setting_type_id: 4 },
  { id: 167, name: %Q(Hide Leaderboard Rules), description: "Leaderboard", app_setting_type_id: 2 },
  { id: 168, name: %Q(Hide Leaderboard Rules), description: "Leaderboard", app_setting_type_id: 4 },
  { id: 169, name: %Q(Disable – My Schedule), description: "My Schedule", app_setting_type_id: 1 },
  { id: 170, name: %Q(Disable – My Schedule), description: "My Schedule", app_setting_type_id: 2 },
  { id: 171, name: %Q(Disable – My Schedule), description: "My Schedule", app_setting_type_id: 4 },
  { id: 172, name: %Q(Disable – QR), description: "QR", app_setting_type_id: 1 },
  { id: 173, name: %Q(Disable – QR), description: "QR", app_setting_type_id: 2 },
  { id: 174, name: %Q(Disable – QR), description: "QR", app_setting_type_id: 4 },
  { id: 175, name: %Q(Users cannot scan a QR code), description: "QR", app_setting_type_id: 4 },
  { id: 176, name: %Q(Events/Users do not have associated region), description: "App", app_setting_type_id: 1 },
  { id: 177, name: %Q(Events do not have associated region), description: "Event", app_setting_type_id: 2 },
  { id: 178, name: %Q(Users do not have associated region), description: "Profile", app_setting_type_id: 4 },
  { id: 179, name: %Q(Users do not have associated region), description: 'Profile', app_setting_type_id: 5 },
  { id: 180, name: %Q(Members cannot see the group they are a part of), description: 'Group', app_setting_type_id: 3 },
  { id: 181, name: %Q(If group doesn’t have a group sponsor, don’t show app sponsor banner ads in that group), description: 'Group', app_setting_type_id: 3 },
  { id: 182, name: %Q(Users can't login), description: 'Security', app_setting_type_id: 4 },
]


SeedData.new('AppSettingOption').load(data)
