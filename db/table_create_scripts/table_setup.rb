# Users
# ========================================================================================================================================================
#rails g scaffold user_hide user:references post:references comment:references created_by:integer:index updated_by:integer:index

#rails g scaffold user_mention user:references post:references comment:references created_by:integer:index updated_by:integer:index

# rails g scaffold user_setting app_label_language:references user:references created_by:integer:index updated_by:integer:index

#rails g scaffold app_admin_user user:references created_by:integer:index updated_by:integer:index


# user_roles
# ========================================================================================================================================================
#rails g scaffold user_role name:string{30} created_by:integer:index updated_by:integer:index

# rails g scaffold user_role_setting setting:boolean user_role_option:references user_role:references created_by:integer:index updated_by:integer:index

# rails g scaffold user_role_option name:string{30} description:string created_by:integer:index updated_by:integer:index


# event_users
# ========================================================================================================================================================
# rails g scaffold event_user event_registration_status:references user:references event:references event_sponsor:references created_by:integer:index updated_by:integer:index

# rails g scaffold user_event_note body:text event_user:references event_speaker:references event_session:references event_sponsor:references event:references created_by:integer:index updated_by:integer:index

# rails g scaffold user_event_bookmark event:references event_user:references event_speaker:references event_session:references event_sponsor:references created_by:integer:index updated_by:integer:index

# rails g scaffold event_user_schedule event_session:references event_user:references created_by:integer:index updated_by:integer:index



# posts
# ========================================================================================================================================================
#rails g scaffold post title:string body:text body_markdown:text excerpt:text thumbnail_teaser_photo display_rank:integer view_count:integer group:references user:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_hide user:references post:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_follower user:references post:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_spam_report user:references post:references post_comment:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_comment body:text user:references post:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_comments_attachment post_comment:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_like user:references post:references created_by:integer:index updated_by:integer:index

# rails g scaffold post_attachment post:references created_by:integer:index updated_by:integer:index

# rails g scaffold group_featured_post post:references group:references created_by:integer:index updated_by:integer:index

# rails g scaffold event_featured_post post:references event:references created_by:integer:index updated_by:integer:index

# groups
# ========================================================================================================================================================
# rails g scaffold group name:string{200} description:text group_is_visible:boolean group_is_leavable:boolean show_member_list:boolean group_type:references owner_user_id:integer:index app_sponsor_id:integer:index created_by:integer:index updated_by:integer:index

# rails g scaffold group_type name:string{50} description:string{100} created_by:integer:index updated_by:integer:index

# rails g scaffold group_member user:references group:references created_by:integer:index updated_by:integer:index

# rails g scaffold group_request user:references group:references pre_auth:boolean approved:boolean created_by:integer:index updated_by:integer:index

# rails g scaffold group_invites user:references group:references created_by:integer:index updated_by:integer:index

# messages
# ======================================================================================================================================================== 
# rails g scaffold message is_viewed:boolean viewed_date:datetime body:text sender_user_id:integer:index recipient_user_id:integer:index reply_message_id:integer:index created_by:integer:index updated_by:integer:index

# rails g scaffold message_attachment message:references created_by:integer:index updated_by:integer:index

# rails g scaffold article_contributor user:references post:references created_by:integer:index updated_by:integer:index


# event
# ======================================================================================================================================================== 
# rails g scaffold event name:string event_begin_date:date event_end_date:date venue_name:string address:string state:string{4} postal_code:string{20} country:references timezone:references group:references created_by:integer:index updated_by:integer:index

# rails g scaffold event_registration_status name:string{50} description:string{100} created_by:integer:index updated_by:integer:index

# rails g scaffold event_follower user:references event:references created_by:integer:index updated_by:integer:index

# rails g scaffold event_session name:string description:text start_date_time:datetime end_date_time:datetime track_name:string{100} breakout_id session_type:string{100} room_name:string{100} is_comments_on:boolean event:references post_id:integer:index event_sponsor:references created_by:integer:index updated_by:integer:index

# rails g scaffold event_speaker first:string{100} last:string{100} title:string organization:string bio:text speaker_type:string{50} moderator:boolean user:references  event_session:references created_by:integer:index updated_by:integer:index

# rails g scaffold event_label_option name:string{50} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold event_setting_option name:string{50} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold event_label_language name:string{50} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold event_session_evaluation survey_link:string session_id:integer:index created_by:integer:index updated_by:integer:index

# rails g scaffold event_evaluation survey_link:string session_id:integer:index created_by:integer:index updated_by:integer:index

# rails g scaffold event_label singular:string plural:string event:references event_label_option_id:integer:index event_label_language_id:integer:index created_by:integer:index updated_by:integer:index

# rails g scaffold event_setting splash_screen_sponsor:string event_sponsor:references is_active:boolean event_setting_option_id:integer:index created_by:integer:index updated_by:integer:index

# rails g scaffold event_leaderboard_option name:string{30} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold event_leaderboard points_allocated:integer event_leaderboard_option_id:integer:index created_by:integer:index updated_by:integer:index


# sponsors
# ======================================================================================================================================================== 
# rails g scaffold event_sponsor name:string description:text logo:string url:string event:references created_by:integer:index updated_by:integer:index

# rails g scaffold sponsor_attachment event_sponsor:references created_by:integer:index updated_by:integer:index

# rails g scaffold app_sponsor name:string sponsor_type description:text logo:string url:string created_by:integer:index updated_by:integer:index

# rails g scaffold app_sponsor_user user:references app_sponsor:references created_by:integer:index updated_by:integer:index

rails g scaffold app_sponsor_type name:string description:string

# app settings
# ======================================================================================================================================================== 
# rails g scaffold app_label_option name:string{50} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold app_setting_option name:string{50} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold app_support body:text created_by:integer:index updated_by:integer:index

# rails g scaffold app_label singular:string plural:string app_label_option:references app_label_language:references created_by:integer:index updated_by:integer:index

# rails g scaffold app_label_language name:string{50} description:string created_by:integer:index updated_by:integer:index

# rails g scaffold app_setting is_setting_enabled:boolean app_setting_option:references event:references group:references user_role:references user:references created_by:integer:index updated_by:integer:index

# rails g scaffold app_email email_from:string email_subject:string email_body:text created_by:integer:index updated_by:integer:index

# rails g scaffold app_label_page name:string{50} description:string created_by:integer:index updated_by:integer:index

# notifications
# ======================================================================================================================================================== 
# rails g scaffold notification is_viewed:boolean body:text link:string type:string user_id:integer:index group_id:integer:index post_id:integer:index connection_id:integer:index created_by:integer:index updated_by:integer:index

# miscellaneous
# ======================================================================================================================================================== 
# rails g scaffold banner_ad group:references event:references graphic_link:text app_sponsor_id:integer:index event_sponsor:references link_url:string{100} created_by:integer:index updated_by:integer:index

# rails g scaffold country name:string{100} abbreviation:string{50} created_by:integer:index updated_by:integer:index

# rails g scaffold timezone name:string{50} offset:integer created_by:integer:index updated_by:integer:index

# rails g scaffold industry_type name:string{50} created_by:integer:index updated_by:integer:index

# rails g scaffold region name:string{50} created_by:integer:index updated_by:integer:index

# rails g scaffold connection body:text is_recipient_approved:boolean sender_user_id:integer:index recipient_user_id:integer:index created_by:integer:index updated_by:integer:index
 
# permision matrix
# ======================================================================================================================================================== 
# rails g scaffold app_setting_type id:integer name:string{50} description:string

# rails g scaffold app_setting_option2 id:integer name:string description:string app_setting_type:references

# rails g scaffold app_setting_dependency id:integer app_setting_option:references app_setting_dependency:references

# rails g scaffold app_setting id:integer is_setting_enabled:boolean app_setting_option:references event:references group:references user_role:references user:references