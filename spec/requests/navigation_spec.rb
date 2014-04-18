require 'spec_helper'

describe 'Navigation' do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @user2 = create(:user, :random)
    @user3 = create(:user, :random)

    @user_connection1 = create(:user_connection, :approved, sender_user: @user,  recipient_user: @user1)
    @user_connection2 = create(:user_connection, :approved, sender_user: @user2, recipient_user: @user)
    @user_connection3 = create(:user_connection, :pending,  sender_user: @user,  recipient_user: @user3)

    @group1 = create(:group, :open)
    @group2 = create(:group, :private)
    @group3 = create(:group, :secret)
    @group4 = create(:group, :random, owner: @user)

    @group_member1 = create(:group_member, user: @user, group: @group1)
    @group_member2 = create(:group_member, user: @user, group: @group2)
    @group_member3 = create(:group_member, user: @user, group: @group3)
    @group_member4 = create(:group_member, user: @user, group: @group4)

    @event_random = create(:event, :random, name: "rando")
    @event_today1 = create(:event, :random, name: "Event One", begin_date: Date.today, end_date: Date.today)
    @event_today2 = create(:event, :random, name: "Event Two", begin_date: Date.today, end_date: Date.today)
    @event_today3 = create(:event, :random, name: "Event Three", begin_date: Date.today, end_date: Date.today)

    @event_user1 = create(:event_user, user: @user, event: @event_random)
    @event_user2 = create(:event_user, :registered, user: @user, event: @event_today1)
    @event_user3 = create(:event_user, :attended, user: @user, event: @event_today2)
    @event_user4 = create(:event_user, :invited, user: @user, event: @event_today3)

    @message1 = create(:message, :random, created_at: Time.now - 1.day, sender_user: @user1, recipient_user: @user)
    @message2 = create(:message, :random, created_at: Time.now - 3.days, sender_user: @user2, recipient_user: @user, viewed_date: Time.now - 2.days)

    @post1 = create(:post, :random, event: @event_random)
    @post2 = create(:post, :random, event: @event_random, creator: @user)
    @post_like = create(:post_like, :random, user: @user, creator: @user, updator: @user)
  end

  it "GET /navigation/left; returns left navigation; nothing disabled, returns all elements" do
    get_auth "/navigation/left"
    response.status.should eql(200)
    json["navigation_left"]["show_messages"].should eq true
    json["navigation_left"]["show_notifications"].should eq true
    json["navigation_left"]["show_search"].should eq true
    json["navigation_left"]["show_user_profile"].should eq true
    json["navigation_left"]["show_posts_count"].should eq true
    json["navigation_left"]["show_likes_count"].should eq true
    json["navigation_left"]["show_connections_count"].should eq true
    json["navigation_left"]["show_groups"].should eq true
    json["navigation_left"]["show_events"].should eq true
    json["navigation_left"]["show_app_sponsors"].should eq true
    json["navigation_left"]["show_support_link"].should eq true
    json["navigation_left"]["new_message_count"].should eq 1
    json["navigation_left"]["new_notification_count"].should eq 1
    json["navigation_left"]["user_headshot"].should eq @user.photo
    json["navigation_left"]["user_full_name"].should eq @user.full_name
    json["navigation_left"]["user_title"].should eq @user.title
    json["navigation_left"]["user_organization"].should eq @user.organization_name
    json["navigation_left"]["user_post_count"].should eq 1
    json["navigation_left"]["user_like_count"].should eq 1
    json["navigation_left"]["user_connection_count"].should eq 2
    json["navigation_left"]["user_events"].count.should eq 3
    json["navigation_left"]["user_today_events"].count.should eq 2
    json["navigation_left"]["user_groups"].count.should eq 3
  end  

  it "GET /navigation/right/:event_id; returns right navigation; nothing disabled, returns all elements" do
    get_auth "/navigation/right/#{@event_random.id}"
    
    response.status.should eql(200)
    json["navigation_right"]["show_attendees"].should eq true
    json["navigation_right"]["show_sessions"].should eq true
    json["navigation_right"]["show_my_schedule"].should eq true
    json["navigation_right"]["show_sponsors"].should eq true
    json["navigation_right"]["show_speakers"].should eq true
    json["navigation_right"]["show_qr_scannable"].should eq true
    json["navigation_right"]["show_qr_scanner"].should eq true
    json["navigation_right"]["show_event_notes"].should eq true
    json["navigation_right"]["show_bookmarks"].should eq true
    json["navigation_right"]["show_leaderboard"].should eq true
    json["navigation_right"]["show_leaderboard_rules"].should eq true
    json["navigation_right"]["show_event_evaluations"].should eq true
  end  

  xit "GET /navigation/left; returns left navigation; app setting turns off todays events (131)" do
    create(:app_setting, app_setting_option_id: 131)

    get_auth "/navigation/left"
    
    response.status.should eql(200)
    json["navigation_left"]["user_today_events"].count.should eq 0
  end

  it "GET /navigation/left; returns the left navigation; post count turned off by app settings (27)" do
    create(:app_setting, app_setting_option_id: 27)

    get_auth "/navigation/left"
    
    response.status.should eql(200)
    json["navigation_left"]["user_post_count"].should eq nil
  end  

  it "GET /navigation/left; returns the left navigation; likes count turned off by app settings (30)" do
    create(:app_setting, app_setting_option_id: 30)

    get_auth "/navigation/left"
    
    response.status.should eql(200)
    json["navigation_left"]["user_like_count"].should eq nil
  end  

  it "GET /navigation/left; returns the left navigation; connections count turned off by app settings (33)" do
    create(:app_setting, app_setting_option_id: 33)

    get_auth "/navigation/left"
    
    response.status.should eql(200)
    json["navigation_left"]["user_connection_count"].should eq nil
  end

  it "GET /navigation/left; all off" do
    create(:app_setting, app_setting_option_id: 24, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 58, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 61)
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 2)
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 1)
    create(:app_setting, app_setting_option_id: 60)

    get_auth "/navigation/left"

    response.status.should eql(200)
    json["navigation_left"]["show_messages"].should eq false
    json["navigation_left"]["show_notifications"].should eq false
    json["navigation_left"]["show_search"].should eq false
    json["navigation_left"]["show_user_profile"].should eq false
    json["navigation_left"]["show_posts_count"].should eq false
    json["navigation_left"]["show_likes_count"].should eq false
    json["navigation_left"]["show_connections_count"].should eq false
    json["navigation_left"]["show_groups"].should eq false
    json["navigation_left"]["show_events"].should eq false
    json["navigation_left"]["show_app_sponsors"].should eq false
    json["navigation_left"]["show_support_link"].should eq false
    json["navigation_left"]["new_message_count"].should eq nil
    json["navigation_left"]["new_notification_count"].should eq nil
    json["navigation_left"]["user_headshot"].should eq nil
    json["navigation_left"]["user_full_name"].should eq nil
    json["navigation_left"]["user_title"].should eq nil
    json["navigation_left"]["user_organization"].should eq nil
    json["navigation_left"]["user_post_count"].should eq nil
    json["navigation_left"]["user_like_count"].should eq nil
    json["navigation_left"]["user_connection_count"].should eq nil
    json["navigation_left"]["user_events"].count.should eq 0
    json["navigation_left"]["user_today_events"].count.should eq 0
    json["navigation_left"]["user_groups"].count.should eq 0
  end

  it "GET /navigation/left; show_likes_count turned off" do
    create(:app_setting, app_setting_option_id: 32, user: @user)

    get_auth "/navigation/left"
    
    response.status.should eql(200)
    json["navigation_left"]["show_likes_count"].should eq false
    
    json["navigation_left"]["show_messages"].should eq true
    json["navigation_left"]["show_notifications"].should eq true
    json["navigation_left"]["show_search"].should eq true
    json["navigation_left"]["show_user_profile"].should eq true
    json["navigation_left"]["show_posts_count"].should eq true
    json["navigation_left"]["show_connections_count"].should eq true
    json["navigation_left"]["show_groups"].should eq true
    json["navigation_left"]["show_events"].should eq true
    json["navigation_left"]["show_app_sponsors"].should eq true
    json["navigation_left"]["show_support_link"].should eq true
    json["navigation_left"]["new_message_count"].should eq 1
    json["navigation_left"]["new_notification_count"].should eq 1
    json["navigation_left"]["user_headshot"].should eq @user.photo
    json["navigation_left"]["user_full_name"].should eq @user.full_name
    json["navigation_left"]["user_title"].should eq @user.title
    json["navigation_left"]["user_organization"].should eq @user.organization_name
    json["navigation_left"]["user_post_count"].should eq 1
    json["navigation_left"]["user_like_count"].should eq nil
    json["navigation_left"]["user_connection_count"].should eq 2
    json["navigation_left"]["user_events"].count.should eq 3
    json["navigation_left"]["user_today_events"].count.should eq 2
    json["navigation_left"]["user_groups"].count.should eq 3
  end

  it "GET /navigation/left; show_groups turned off" do
    create(:app_setting, app_setting_option_id: 3, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 2)

    get_auth "/navigation/left"
    response.status.should eql(200)
    json["navigation_left"]["show_messages"].should eq true
    json["navigation_left"]["show_notifications"].should eq true
    json["navigation_left"]["show_search"].should eq true
    json["navigation_left"]["show_user_profile"].should eq true
    json["navigation_left"]["show_posts_count"].should eq true
    json["navigation_left"]["show_likes_count"].should eq true
    json["navigation_left"]["show_connections_count"].should eq true
    json["navigation_left"]["show_groups"].should eq false
    json["navigation_left"]["show_events"].should eq true
    json["navigation_left"]["show_app_sponsors"].should eq true
    json["navigation_left"]["show_support_link"].should eq true
    json["navigation_left"]["new_message_count"].should eq 1
    json["navigation_left"]["new_notification_count"].should eq 1
    json["navigation_left"]["user_headshot"].should eq @user.photo
    json["navigation_left"]["user_full_name"].should eq @user.full_name
    json["navigation_left"]["user_title"].should eq @user.title
    json["navigation_left"]["user_organization"].should eq @user.organization_name
    json["navigation_left"]["user_post_count"].should eq 1
    json["navigation_left"]["user_like_count"].should eq 1
    json["navigation_left"]["user_connection_count"].should eq 2
    json["navigation_left"]["user_events"].count.should eq 3
    json["navigation_left"]["user_today_events"].count.should eq 2
    json["navigation_left"]["user_groups"].count.should eq 0
  end


  it "GET /navigation/left; gets the left navigation events turned off" do
    create(:app_setting, app_setting_option_id: 126, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 125)

    get_auth "/navigation/left"
    response.status.should eql(200)
    json["navigation_left"]["show_messages"].should eq true
    json["navigation_left"]["show_notifications"].should eq true
    json["navigation_left"]["show_search"].should eq true
    json["navigation_left"]["show_user_profile"].should eq true
    json["navigation_left"]["show_posts_count"].should eq true
    json["navigation_left"]["show_likes_count"].should eq true
    json["navigation_left"]["show_connections_count"].should eq true
    json["navigation_left"]["show_groups"].should eq true
    json["navigation_left"]["show_events"].should eq false
    json["navigation_left"]["show_app_sponsors"].should eq true
    json["navigation_left"]["show_support_link"].should eq true
    json["navigation_left"]["new_message_count"].should eq 1
    json["navigation_left"]["new_notification_count"].should eq 1
    json["navigation_left"]["user_headshot"].should eq @user.photo
    json["navigation_left"]["user_full_name"].should eq @user.full_name
    json["navigation_left"]["user_title"].should eq @user.title
    json["navigation_left"]["user_organization"].should eq @user.organization_name
    json["navigation_left"]["user_post_count"].should eq 1
    json["navigation_left"]["user_like_count"].should eq 1
    json["navigation_left"]["user_connection_count"].should eq 2
    json["navigation_left"]["user_events"].count.should eq 0
    json["navigation_left"]["user_today_events"].count.should eq 0
    json["navigation_left"]["user_groups"].count.should eq 3
  end

  it "GET /navigation/right/:event_id; show_attendees turned off" do
    create(:app_setting, app_setting_option_id: 16, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 13)
    create(:app_setting, app_setting_option_id: 14, event: @event_random)

    get_auth "/navigation/right/#{@event_random.id}"
    response.status.should eql(200)
    json["navigation_right"]["show_attendees"].should eq false
    json["navigation_right"]["show_sessions"].should eq true
    json["navigation_right"]["show_my_schedule"].should eq true
    json["navigation_right"]["show_sponsors"].should eq true
    json["navigation_right"]["show_speakers"].should eq true
    json["navigation_right"]["show_qr_scannable"].should eq true
    json["navigation_right"]["show_qr_scanner"].should eq true
    json["navigation_right"]["show_event_notes"].should eq true
    json["navigation_right"]["show_bookmarks"].should eq true
    json["navigation_right"]["show_leaderboard"].should eq true
    json["navigation_right"]["show_leaderboard_rules"].should eq true
    json["navigation_right"]["show_event_evaluations"].should eq true
  end

  it "GET /navigation/right/:event_id; all off" do
    create(:app_setting, app_setting_option_id: 14, event: @event_random)
    create(:app_setting, app_setting_option_id: 141, event: @event_random)
    create(:app_setting, app_setting_option_id: 171, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 139, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 144, event: @event_random)
    create(:app_setting, app_setting_option_id: 174, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 175, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 148, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 150, event: @event_random)
    create(:app_setting, app_setting_option_id: 159, event: @event_random)
    create(:app_setting, app_setting_option_id: 167, event: @event_random)
    create(:app_setting, app_setting_option_id: 152)

    get_auth "/navigation/right/#{@event_random.id}"
    
    response.status.should eql(200)
    json["navigation_right"]["show_attendees"].should eq false
    json["navigation_right"]["show_sessions"].should eq false
    json["navigation_right"]["show_my_schedule"].should eq false
    json["navigation_right"]["show_sponsors"].should eq false
    json["navigation_right"]["show_speakers"].should eq false
    json["navigation_right"]["show_qr_scannable"].should eq false
    json["navigation_right"]["show_qr_scanner"].should eq false
    json["navigation_right"]["show_event_notes"].should eq false
    json["navigation_right"]["show_bookmarks"].should eq false
    json["navigation_right"]["show_leaderboard"].should eq false
    json["navigation_right"]["show_leaderboard_rules"].should eq false
    json["navigation_right"]["show_event_evaluations"].should eq false
  end

end