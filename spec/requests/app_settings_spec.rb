require 'spec_helper'

describe 'AppSetting' do

  before(:all) do
    @user = create(:user)
  end

  it "GET /app_settings/; invalid app_setting name" do
    get_auth "/app_settings/?names[]=foo_bar"
    
    response.status.should eql(422)
  end

  it "GET /app_settings/; show_likes_count turned on" do
    get_auth "/app_settings/?names[]=show_likes_count"
    
    response.status.should eql(200)
    json["show_likes_count"].should eq true
  end  

  it "GET /app_settings/; todays_event_callout turned on" do
    event = create(:event, :random, :future )
    get_auth "/app_settings/?names[]=todays_event_callout&event_id=#{event.id}"
    response.status.should eql(200)
    json["todays_event_callout"].should eq true
  end  

  it "GET /app_settings/; combine_past_and_upcoming_events turned on" do
    get_auth "/app_settings/?names[]=combine_past_and_upcoming_events"
    
    response.status.should eql(200)
    json["combine_past_and_upcoming_events"].should eq true
  end  

  it "GET /app_settings/; combine_past_and_upcoming_events turned on" do
    get_auth "/app_settings/?names[]=combine_past_and_upcoming_events"
    
    response.status.should eql(200)
    json["combine_past_and_upcoming_events"].should eq true
  end  

  it "GET /app_settings/; event_follows turned on" do
    event = create(:event, :random, :future )
    get_auth "/app_settings/?names[]=event_follows&event_id=#{event.id}"
    
    response.status.should eql(200)
    json["event_follows"].should eq true
  end

  it "GET /app_settings/; show_likes_count turned off" do
    create(:app_setting, app_setting_option_id: 30)
    
    get_auth "/app_settings/?names[]=show_likes_count"
    
    response.status.should eql(200)
    json["show_likes_count"].should eq false
  end

  it "GET /app_settings/; show_likes_count turned off" do
    create(:app_setting, app_setting_option_id: 32, user: @user)
    create(:app_setting, app_setting_option_id: 31, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 112, user_role: @user.user_role)
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)    
    create(:app_setting, app_setting_option_id: 30)
    create(:app_setting, app_setting_option_id: 109)
    create(:app_setting, app_setting_option_id: 21)
   
    get_auth "/app_settings/?names[]=show_likes_count"
    
    response.status.should eql(200)
    json["show_likes_count"].should eq false
  end

  it "GET /app_settings/; view_events_not_part_of" do
    get_auth "/app_settings/?names[]=view_events_not_a_part_of"
    
    response.status.should eql(200)
    json["view_events_not_a_part_of"].should eq true
  end  

  it "GET /app_settings/; event_sponsors" do
    event = create(:event, :random, :future )
    
    get_auth "/app_settings/?names[]=event_sponsors&event_id=#{event.id}"
    
    response.status.should eql(200)
    json["event_sponsors"].should eq true
  end  

  it "GET /app_settings/; event_notes" do
    event = create(:event, :random, :future )

    get_auth "/app_settings/?names[]=event_notes&event_id=#{event.id}"
    
    response.status.should eql(200)
    json["event_notes"].should eq true
  end

  it "GET /app_settings/; event following turned off" do
    create(:app_setting, app_setting_option_id: 125)
    get_auth "/app_settings/?names[]=event_follows"

    response.status.should eql(200)

    json["event_follows"].should eq false
  end  

  it "GET /app_settings/:name; event splash page turned on" do
    event = create(:event, :random, :future )

    get_auth "/app_settings/?names[]=event_splash_page&event_id=#{event.id}"

    response.status.should eql(200)
    json["event_splash_page"].should eq true
  end   

  it "GET /app_settings/:name; event splash page turned on" do
    event = create(:event, :random, :future )
    get_auth "/app_settings/?names[]=event_splash_page&event_id=#{event.id}"

    response.status.should eql(200)
    json["event_splash_page"].should eq true
  end   

  it "GET /app_settings/:name; event_follows" do
    event = create(:event, :random, :future )
    get_auth "/app_settings/?names[]=event_follows&event_id=#{event.id}"

    response.status.should eql(200)
    json["event_follows"].should eq true
  end   

  it "GET /app_settings/:name; event_info" do
    event = create(:event, :random, :future )
    get_auth "/app_settings/?names[]=event_info&event_id=#{event.id}"

    response.status.should eql(200)
    json["event_info"].should eq true
  end  

  it "GET /app_settings/; Multi App Setting checker" do
    create(:app_setting, app_setting_option_id: 104, user_role: @user.user_role)
    event = create(:event, :random)
    group = create(:group, :open)
    get_auth "/app_settings/?names[]=support_link&names[]=send_messages&names[]=groups_in_navigation&names[]=show_me_on_lists&names[]=like_posts&names[]=show_group_member_list&names[]=post_comment_updates&names[]=delete_post_warning&names[]=event_session_evaluations&group_id=#{group.id}&event_id=#{event.id}"
    
    response.status.should eql(200)
    json["support_link"].should eq true
    json["send_messages"].should eq true
    json["groups_in_navigation"].should eq true
    json["show_me_on_lists"].should eq true
    json["like_posts"].should eq true
    json["show_group_member_list"].should eq true
    json["event_session_evaluations"].should eq true
    json["post_comment_updates"].should eq false
    json["delete_post_warning"].should eq true
  end

  it "GET /app_settings/; Multi App Setting checker - more options" do
    create(:app_setting, app_setting_option_id: 115, user_role: @user.user_role)
    event = create(:event, :random)
    group = create(:group, :open)
    get_auth "/app_settings/?names[]=view_attachments&group_id=#{group.id}&event_id=#{event.id}"
    response.status.should eql(200)
    json["view_attachments"].should eq false
  end

  it "GET /app_settings/:name; checks on support link; should be false b/c of app setting (60)" do
    create(:app_setting, app_setting_option_id: 60)

    get_auth "app_settings/?names[]=support_link"

    response.status.should eql(200)
    json["support_link"].should eq false
  end    

  xit "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (86)" do
    create(:app_setting, app_setting_option_id: 86)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end    

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end  

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end    

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end    

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (76)" do
    create(:app_setting, app_setting_option_id: 76, user_role: @user.user_role)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end    

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (83)" do
    create(:app_setting, app_setting_option_id: 83)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end   

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (84)" do
    create(:app_setting, app_setting_option_id: 84, user_role: @user.user_role)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end    

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (85)" do
    create(:app_setting, app_setting_option_id: 85)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end   

  it "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (95)" do
    create(:app_setting, app_setting_option_id: 95)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end   

  xit "GET /app_settings/:name; checks on post edit warning; should be false b/c of app setting (98)" do
    create(:app_setting, app_setting_option_id: 98)

    get_auth "app_settings/?names[]=edit_post_warning"

    response.status.should eql(200)
    json["edit_post_warning"].should eq false
  end    

  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (92)" do
    create(:app_setting, app_setting_option_id: 92, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
   
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
  
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
  
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
   
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (76)" do
    create(:app_setting, app_setting_option_id: 76, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
   
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (89)" do
    create(:app_setting, app_setting_option_id: 89)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
   
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (90)" do
    create(:app_setting, app_setting_option_id: 90, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
   
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (91)" do
    create(:app_setting, app_setting_option_id: 91)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end  
   
  it "GET /app_settings/:name; checks on post delete warning; should be false b/c of app setting (95)" do
    create(:app_setting, app_setting_option_id: 95)

    get_auth "app_settings/?names[]=delete_post_warning"

    response.status.should eql(200)
    json["delete_post_warning"].should eq false
  end   

  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (108)" do
    create(:app_setting, app_setting_option_id: 108, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (95)" do
    create(:app_setting, app_setting_option_id: 95)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (98)" do
    create(:app_setting, app_setting_option_id: 98, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (105)" do
    create(:app_setting, app_setting_option_id: 105)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (106)" do
    create(:app_setting, app_setting_option_id: 106, user_role: @user.user_role)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
 
  it "GET /app_settings/:name; checks on comment delete warning; should be false b/c of app setting (107)" do
    create(:app_setting, app_setting_option_id: 107)

    get_auth "app_settings/?names[]=delete_comment_warning"

    response.status.should eql(200)
    json["delete_comment_warning"].should eq false
  end  
  
  it "DELETE /app_settings/:id; setting exists, will be deleted" do
    app_setting = create(:app_setting, app_setting_option_id: 56, user: @user)
    delete_auth "/app_settings/#{app_setting.id}"
    response.status.should eq(204)
  end

  it "DELETE /app_settings/:id; setting exists but options are disabled for user_role" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    app_setting = create(:app_setting, app_setting_option_id: 56, user: @user)
    delete_auth "/app_settings/#{app_setting.id}"
    response.status.should eq(403)
  end

  it "DELETE /app_settings/:id; attempt to delete another user's app_setting" do
    app_setting = create(:app_setting, app_setting_option_id: 56, user: create(:user, :random))
    delete_auth "/app_settings/#{app_setting.id}"
    response.status.should eq(403)
  end

  it "DELETE /app_settings/:id; attempt to delete an app level app_setting, invalid" do
    app_setting = create(:app_setting, app_setting_option_id: 52)
    delete_auth "/app_settings/#{app_setting.id}"
    response.status.should eq(403)
  end

  it "DELETE /app_settings/:id; attempt to delete an app_setting not available becuase of upstream settings" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    app_setting = create(:app_setting, app_setting_option_id: 56, user: create(:user, :random))
    delete_auth "/app_settings/#{app_setting.id}"
    response.status.should eq(403)
  end

  it "DELETE /app_settings/:id; app_setting doesn't exists, 404" do
    delete_auth "/app_settings/0"
    response.status.should eq(404)
  end

  it "POST /app_settings; create app_setting 56 for current user" do
    post_auth "/app_settings", { app_setting: {app_setting_option_id: 56 } }
    response.status.should eq(201)
    json["app_setting"]["app_setting_option_id"].should eq 56
    json["app_setting"]["app_level_setting"].should eq nil
    json["app_setting"]["event_id"].should eq nil
    json["app_setting"]["group_id"].should eq nil
    json["app_setting"]["user_role_id"].should eq nil
    json["app_setting"]["user_id"].should eq @user.id
    json["app_setting"]["created_by"].should eq @user.id
    json["app_setting"]["updated_by"].should eq @user.id
  end

  it "POST /app_settings; attempt to create app_setting 55 for current user, invalid because 55 is a user_role level setting" do
    post_auth "/app_settings", { app_setting: {app_setting_option_id: 55 } }
    response.status.should eq(403)
  end

  it "POST /app_settings; attempt to create app_setting 56 for current user, option is disabled for user_role" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    post_auth "/app_settings", { app_setting: {app_setting_option_id: 56 } }
    response.status.should eq(403)
  end

  it "POST /app_settings; attempt to create app_setting 0 (doesn't exist), invalid" do
    post_auth "/app_settings", { app_setting: {app_setting_option_id: 0 } }
    response.status.should eq(422)
  end

  it "POST /app_settings; attempt to create app_setting 56 for current user, already exists" do
    app_setting = create(:app_setting, app_setting_option_id: 56, user: @user)
    post_auth "/app_settings", { app_setting: {app_setting_option_id: 0 } }
    response.status.should eq(422)
  end
end