class AppSettings::Key

  def self.find(key)

    keys = {}

    keys[:groups] = [2]
    keys[:messages] = [44]
    keys[:notifications] = [58]
    keys[:search] = [63]
    keys[:user_profile] = [22]
    keys[:show_posts_count] = [29]
    keys[:show_likes_count] = [32]
    keys[:show_connections_count] = [35]
    keys[:groups_in_navigation] = [3]
    keys[:events] = [126]
    keys[:app_sponsors] = [1]
    keys[:join_groups] = [7]
    keys[:support_link] = [60]

    keys[:show_attendees] = [14, 16]
    keys[:event_sessions] = [141, 142]
    keys[:event_my_schedule] = [170, 171]
    keys[:event_sponsors] = [138, 139]
    keys[:event_speakers] = [144, 145]
    keys[:event_qr_scannable] = [173, 174]
    keys[:event_qr_scanner] = [173, 175]
    keys[:event_notes] = [147, 148]
    keys[:event_bookmarks] = [150, 151]
    keys[:event_leaderboard] = [159, 160]
    keys[:show_leaderboard_rules] = [167, 168]
    keys[:event_evaluations] = [153]
    keys[:user_event_evaluations] = [157]

    keys[:user_event_notes] = [148]
    keys[:user_event_bookmarks] = [151]

    keys[:event_follows] = [128]

    keys[:group_creation] = [9]
    keys[:group_leaves] = [11, 12]
    keys[:show_group_memberships] = [180]

    keys[:event_session_evaluations] = [155, 156]
    keys[:show_attendees_only_after_event_starts] = [20]
    keys[:show_me_on_lists] = [18]

    keys[:post_comments] = [98]
    keys[:event_post_comments] = [96, 98]
    keys[:group_post_comments] = [97, 98]
    
    keys[:post_and_session_likes] = [110, 112]

    keys[:post_comment_updates] = [104]

    keys[:like_posts] = [112]
    keys[:like_group_posts] = [111]
    keys[:like_event_posts] = [110]
    keys[:show_post_likes_list] = [114]

    keys[:create_event_posts] = [74, 76]
    keys[:create_group_posts] = [75, 76]
    keys[:create_user_posts] = [76]
    keys[:post_edits] = [83]
    keys[:post_deletes] = [90]

    keys[:edit_post_warning] = [86]
    keys[:delete_post_warning] = [92]
    keys[:delete_comment_warning] = [108]

    keys[:show_group_member_list] = [15, 16]
    keys[:show_group_member_list_connections] = [15, 16, 47]
    keys[:show_me_on_group_lists] = [15, 18]
    keys[:connections] = [47]
    keys[:user_connections] = [50]
    keys[:block_viewing_my_connections] = [51]

    keys[:send_messages] = [43]
    keys[:receive_messages] = [46]
    keys[:receive_messages_from_connections] = [45]
    keys[:todays_event_callout] = [132]
    keys[:combine_past_and_upcoming_events] = [129]
    keys[:event_splash_page] = [127]
    keys[:event_info] = [134]

    keys[:articles] = [77, 78]
    keys[:mentions] = [53, 55]
    keys[:event_post_attachments] = [80, 82]
    keys[:group_post_attachments] = [81, 82]
    keys[:view_profiles] = [24]
    keys[:profiles] = [21]

    keys[:hide_app_sponsors_on_group] = [181]
    keys[:view_events_not_a_part_of] = [136]
    keys[:view_attended_events] = [130]

    keys[:account_active] = [182]
    keys[:edit_profile] = [26]
    keys[:view_attachments] = [115]

    # keys[:user_at_mention] = [56]

    keys[key]

  end

end