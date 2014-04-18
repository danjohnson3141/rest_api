require 'spec_helper'

describe 'UsersProfile' do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @user2 = create(:user, :random)

    @group1 = create(:group, :open, name: 'ZZZ')
    @group2 = create(:group, :private, name: 'YYY')
    @group3 = create(:group, :secret, name: 'CCC')
    @group4 = create(:group, :random, owner: @user, name: 'AAA')

    @group_member1 = create(:group_member, user: @user, group: @group1)
    @group_member2 = create(:group_member, user: @user, group: @group2)
    @group_member3 = create(:group_member, user: @user, group: @group3)
    @group_member4 = create(:group_member, user: @user, group: @group4)

    @event_random = create(:event, :random, name: "000 rando")
    @event_today1 = create(:event, :random, name: "ZZZ Event One", begin_date: Date.today, end_date: Date.today)
    @event_today2 = create(:event, :random, name: "AAA Event Two", begin_date: Date.today, end_date: Date.today)
    @event_today3 = create(:event, :random, name: "FFF Event Three", begin_date: Date.today, end_date: Date.today)

    @event_user1 = create(:event_user, user: @user, event: @event_random)
    @event_user2 = create(:event_user, :registered, user: @user, event: @event_today1)
    @event_user3 = create(:event_user, :attended, user: @user, event: @event_today2)
    @event_user4 = create(:event_user, :invited, user: @user, event: @event_today3)

    @post1 = create(:post, :random, :group, creator: @user)
    @post2 = create(:post, :random, event: @event_random, creator: @user)
    @post3 = create(:post, :random, event: @event_random, creator: @user1)
    @post2 = create(:post, :random, event: @event_random, creator: @user2)
    @post_like1 = create(:post_like, :random, user: @user, creator: @user, updator: @user)
    @post_like2 = create(:post_like, :random, user: @user, creator: @user, updator: @user)
    @post_like3 = create(:post_like, :random, user: @user2, creator: @user2, updator: @user2)
  end

    
  it "GET /user/profile/:id; message another user, disabled at user level (46)" do
    create(:app_setting, app_setting_option_id: 46, user: @user1)
    get_auth "/users/profile/#{@user1.id}"
    response.status.should eql(200)
    json["user"]["can_message"].should eq false
  end

  it "GET /user/profile/:id; message another user, disabled at user_role level (43)" do
    create(:app_setting, app_setting_option_id: 43, user_role: @user.user_role)
    
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eql(200)
    json["user"]["can_message"].should eq false
  end

  it "GET users/profile; receives the logged in users profile" do
    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["last_name"].should eq(@user.last_name)
    json["user"]['post_count'].should eq 2
  end

  it "PATCH users/profile; updates the logged in users profile" do
    patch_auth '/users/profile', 
      { user: 
        { alt_email: "alt@example.com", 
          bio: "I'm totally awesome!!", 
          first_name: "Awesome", 
          last_name: "UserTest", 
          organization_name: "Testing is awesome!", 
          photo: "www.example.com/updated.gif", 
          title: "King of the World"   } }

    response.status.should eq(204)
    updated_user = User.find_by_id(@user.id)
    updated_user.alt_email.should eq("alt@example.com")
    updated_user.bio.should eq("I'm totally awesome!!")
    updated_user.first_name.should eq("Awesome")
    updated_user.last_name.should eq("UserTest")
    updated_user.organization_name.should eq("Testing is awesome!")
    updated_user.photo.should eq("www.example.com/updated.gif")
    updated_user.title.should eq("King of the World")
  end  

  it "PUT users/profile; updates the logged in users profile" do
    put_auth '/users/profile', { user: { last_name: "UserTest" } }

    response.status.should eq(204)
    updated_user = User.find_by_id(@user.id)
    updated_user.last_name.should eq("UserTest")
  end

  it "PATCH users/profile; attempts to update the logged in users profile, fails because of required field" do
    patch_auth '/users/profile', { user: { last_name: nil } }

    response.status.should eq(422)
  end

  it "GET /users/profile/:id; receives the profile of a different user" do
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user1.email
  end

  it "GET /users/profile/:id; other users profile - yes messages" do
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user1.email
    json["user"]["can_message"].should eq true
  end


  it "GET /users/profile/:id; different user - posts/likes count" do
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user1.email
    json["user"]["post_count"].should eq 1
    json["user"]["post_like_count"].should eq 0
  end

  it "GET /users/profile/:id; different user - posts/likes count" do
    get_auth "/users/profile/#{@user2.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user2.email
    json["user"]["post_count"].should eq 1
    json["user"]["post_like_count"].should eq 1
  end

  it "GET /users/post_options; user's groups and events" do
    group_ignore = create(:group, :random, :open)
    event_ignore = create(:event, :random, group: create(:group, :random, :open))

    get_auth "/users/post_options"
    
    response.status.should eq(200)
    json["user"]["id"].should eq @user.id
    json["user"]["groups"].count.should eq 4
    json["user"]["events"].count.should eq 4
    json["user"]["events"].first["name"].should eq @event_random.name
    json["user"]["events"].fourth["name"].should eq @event_today1.name
    json["user"]["groups"].first["name"].should eq @group4.name
    json["user"]["groups"].last["name"].should eq @group1.name
    json["user"]["events"].to_s.should_not include event_ignore.name
    json["user"]["groups"].to_s.should_not include group_ignore.name

  end

  it "GET /users/profile; check for existance of profile" do
    get_auth "/users/profile/#{@user1.id}"

    response.status.should eq (200)
    json["user"]["id"].should eq @user1.id
    json["user"]['user_profile'].should eq true
  end

  it "GET /users/profile; your attended events" do
    event1 = create(:event, :random, name: "123 Event One", begin_date: Date.today - 10.day, end_date: Date.today)
    event2 = create(:event, :random, name: "456 Event Two", begin_date: Date.today - 15.days, end_date: Date.today)
    create(:event_user, :attended, user: @user, event: event1)
    create(:event_user, :attended, user: @user, event: event2)

    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['attended_events'].count.should eq 3
    json["user"]['attended_events'][0]["id"].should eq @event_today2.id
    json["user"]['attended_events'][1]["id"].should eq event1.id
    json["user"]['attended_events'][2]["id"].should eq event2.id
  end

  it "GET /users/profile/:id; another user's attended events" do
    event1 = create(:event, :random, name: "123 Event One", begin_date: Date.today - 10.day, end_date: Date.today)
    event2 = create(:event, :random, name: "456 Event Two", begin_date: Date.today - 15.days, end_date: Date.today)
    create(:event_user, :attended, user: @user1, event: event1)
    create(:event_user, :attended, user: @user1, event: event2)
    create(:group_member, user: @user, group: event1.group)
    create(:group_member, user: @user, group: event2.group)

    get_auth "/users/profile/#{@user1.id}"
    
    json["user"]["id"].should eq @user1.id
    json["user"]['attended_events'].count.should eq 2
    json["user"]['attended_events'][0]["id"].should eq event1.id
    json["user"]['attended_events'][1]["id"].should eq event2.id
  end

  it "GET /users/profile; your groups" do
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]["groups"].count.should eq 4
    json["user"]['groups'][0]["id"].should eq @group4.id
    json["user"]['groups'][1]["id"].should eq @group3.id
    json["user"]['groups'][2]["id"].should eq @group2.id
    json["user"]['groups'][3]["id"].should eq @group1.id
  end

  it "GET /users/profile/:id; another user's groups - with both users in a secret group" do
    create(:group_member, user: @user1, group: @group1)
    create(:group_member, user: @user1, group: @group2)
    create(:group_member, user: @user1, group: @group3)

    get_auth "/users/profile/#{@user1.id}"
    
    json["user"]["id"].should eq @user1.id
    json["user"]["groups"].count.should eq 3
    json["user"]['groups'][0]["id"].should eq @group3.id
    json["user"]['groups'][1]["id"].should eq @group2.id
    json["user"]['groups'][2]["id"].should eq @group1.id
  end

  it "GET /users/profile/:id; another user's groups - other user in a secret group only" do
    secret_group = create(:group, :secret, name: 'XYZ Secret')
    create(:group_member, user: @user1, group: @group1)
    create(:group_member, user: @user1, group: @group2)
    create(:group_member, user: @user1, group: secret_group)

    get_auth "/users/profile/#{@user1.id}"
    
    json["user"]["id"].should eq @user1.id
    json["user"]["groups"].count.should eq 2
    json["user"]['groups'][0]["id"].should eq @group2.id
    json["user"]['groups'][1]["id"].should eq @group1.id
  end

  it "GET /users/profile; show your connection count" do
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['user_connection_count'].should eq 0
  end

  it "GET /users/profile/:id; show another users post like count" do
    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['post_like_count'].should eq 0
  end

  it "GET /users/profile/:id; show another users connection count" do
    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['user_connection_count'].should eq 0
  end

  it "GET /users/profile; show your post count" do
    get_auth "/users/profile"

    json["user"]["id"].should eq @user.id
    json["user"]['post_count'].should eq 2
  end

  it "GET /users/profile/:id; show another users post count" do
    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['post_count'].should eq 1
  end

  it "GET /users/profile; show your post like count" do
    get_auth "/users/profile"

    json["user"]["id"].should eq @user.id
    json["user"]['post_like_count'].should eq 2
  end

  it "GET /users/profile; edit your own profile - enabled" do
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['can_edit_profile'].should eq true
  end

  it "GET /users/profile/:id; edit another users profile" do
    get_auth "/users/profile/#{@user1.id}"
    
    json["user"]["id"].should eq @user1.id
    json["user"]['can_edit_profile'].should eq false
  end
 
  it "GET /users/profile/:id; edit another users profile" do
    get_auth "/users/profile/#{@user1.id}"
    json["user"]["id"].should eq @user1.id
    json["user"]['can_edit_profile'].should eq false
  end

  it "GET /users/profile/:id; notes for another user" do
    event_user1 = create(:event_user, user: @user1, event: @event_random)
    event_user2 = create(:event_user, :registered, user: @user1, event: @event_today1)
    event_user3 = create(:event_user, :attended, user: @user1, event: @event_today2)
    event_note1 = create(:event_note, :random, event_user: event_user1, creator: @user)
    event_note2 = create(:event_note, :random, event_user: event_user2, creator: @user)
    event_note3 = create(:event_note, :random, event_user: event_user3, creator: @user)

    get_auth "/users/profile/#{@user1.id}"
    json["user"]["id"].should eq @user1.id
    json["user"]["event_notes"].count.should eq 3
  end

  it "GET /users/profile; hide your attended events - app setting (130)" do
    create(:app_setting, app_setting_option_id: 130, user: @user)
    event1 = create(:event, :random, name: "123 Event One", begin_date: Date.today - 10.day, end_date: Date.today)
    event2 = create(:event, :random, name: "456 Event Two", begin_date: Date.today - 15.days, end_date: Date.today)
    create(:event_user, :attended, user: @user, event: event1)
    create(:event_user, :attended, user: @user, event: event2)

    get_auth "/users/profile"

    json["user"]["id"].should eq @user.id
    json["user"]['attended_events'].count.should eq 0
  end

  it "GET /users/profile; hide your connection count - app setting (35)" do
    create(:app_setting, app_setting_option_id: 35, user: @user)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['user_connection_count'].should eq nil
  end  

  it "GET /users/profile; hide users posts count, app setting (28)" do
    create(:app_setting, app_setting_option_id: 28, user_role: @user.user_role)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['post_count'].should eq nil
  end  

  it "GET /users/profile; hide users posts count, app setting (76)" do
    create(:app_setting, app_setting_option_id: 76, user_role: @user.user_role)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['post_count'].should eq nil
  end

  it "GET /users/profile; hide your connection count - app setting (51)" do
    create(:app_setting, app_setting_option_id: 51, user: @user)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['user_connection_count'].should eq nil
  end

  it "GET /users/profile; hide your connection count app setting (48)" do
    create(:app_setting, app_setting_option_id: 48, user_role: @user.user_role)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['user_connection_count'].should eq nil
  end  

  it "GET /users/profile; hide your connection count app setting (34)" do
    create(:app_setting, app_setting_option_id: 34, user_role: @user.user_role)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['user_connection_count'].should eq nil
  end

  it "PATCH users/profile; attemps to updates active user's profile; fails because of app setting (25)" do
    create(:app_setting, app_setting_option_id: 25)

    patch_auth '/users/profile', { user: { alt_email: "alt@example.com" } }

    response.status.should eq(403)
  end  

  it "PUT users/profile; attemps to updates active user's profile; fails because of app setting (25)" do
    create(:app_setting, app_setting_option_id: 25)

    put_auth '/users/profile', { user: { alt_email: "alt@example.com" } }

    response.status.should eq(403)
  end

  it "PUT users/profile; updates the logged in users profile - when disabled (26)" do
    create(:app_setting, app_setting_option_id: 26, user_role: @user.user_role)
    
    put_auth '/users/profile', { user: { last_name: "UserTest" } }

    response.status.should eq(403)
    User.find_by_id(@user.id).should_not eq("UserTest")
  end

  it "GET /users/profile; check for non-existance of profile - app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user1.user_role)

    get_auth "/users/profile/#{@user1.id}"
    response.status.should eq(404)
  end

  it "GET /users/profile/:id; another user's attended events - when hidden - app setting (130)" do
    create(:app_setting, app_setting_option_id: 130, user: @user1)
    event1 = create(:event, :random, name: "123 Event One", begin_date: Date.today - 10.day, end_date: Date.today)
    event2 = create(:event, :random, name: "456 Event Two", begin_date: Date.today - 15.days, end_date: Date.today)
    create(:event_user, :attended, user: @user, event: event1)
    create(:event_user, :attended, user: @user, event: event2)
    create(:event_user, :attended, user: @user1, event: event1)
    create(:event_user, :attended, user: @user1, event: event2)

    get_auth "/users/profile/#{@user1.id}"
    
    json["user"]["id"].should eq @user1.id
    json["user"]['attended_events'].count.should eq 0
  end

  it "GET /users/profile/:id; hide another users connection count - app setting (35)" do
    create(:app_setting, app_setting_option_id: 35, user: @user1)

    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['user_connection_count'].should eq nil
  end

  it "GET /users/profile/:id; hide another users connection count - app setting (51)" do
    create(:app_setting, app_setting_option_id: 51, user: @user1)

    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['user_connection_count'].should eq nil
  end

  it "GET /users/profile/:id; hide another users connection count - app setting (50)" do
    create(:app_setting, app_setting_option_id: 50, user: @user1)

    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['user_connection_count'].should eq nil
  end

  it "GET /users/profile/:id; hide another users connection count - app setting (48)" do
    create(:app_setting, app_setting_option_id: 48, user_role: @user1.user_role)

    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['user_connection_count'].should eq nil
  end


  it "GET /users/profile; hide your post like count - app setting (32)" do
    create(:app_setting, app_setting_option_id: 32, user: @user)

    get_auth "/users/profile"

    json["user"]["id"].should eq @user.id
    json["user"]['post_like_count'].should eq nil
  end

  it "GET /users/profile/:id; hide another users post like count - app setting (32)" do
    create(:app_setting, app_setting_option_id: 32, user: @user1)

    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['post_like_count'].should eq nil
  end

  it "GET /users/profile; hide your post count - app setting (29)" do
    create(:app_setting, app_setting_option_id: 29, user: @user)

    get_auth "/users/profile"

    json["user"]["id"].should eq @user.id
    json["user"]['post_count'].should eq nil
  end

  it "GET /users/profile/:id; hide another users post count - app setting (29)" do
    create(:app_setting, app_setting_option_id: 29, user: @user1)
    get_auth "/users/profile/#{@user1.id}"
    json["user"]["id"].should eq @user1.id
    json["user"]['post_count'].should eq nil
  end

  it "GET /users/profile; edit your own profile - disabled - app setting (26)" do
    create(:app_setting, app_setting_option_id: 26, user_role: @user.user_role)
    
    get_auth "/users/profile"
    
    json["user"]["id"].should eq @user.id
    json["user"]['can_edit_profile'].should eq false
  end
 
  it "GET /users/profile/:id; notes for another user - when disabled user_role (148)" do
    create(:app_setting, app_setting_option_id: 148, user_role: @user.user_role)
    event_user1 = create(:event_user, user: @user1, event: @event_random)
    event_user2 = create(:event_user, :registered, user: @user1, event: @event_today1)
    event_user3 = create(:event_user, :attended, user: @user1, event: @event_today2)
    event_note1 = create(:event_note, :random, event_user: event_user1, creator: @user)
    event_note2 = create(:event_note, :random, event_user: event_user2, creator: @user)
    event_note3 = create(:event_note, :random, event_user: event_user3, creator: @user)

    get_auth "/users/profile/#{@user1.id}"
    json["user"]["id"].should eq @user1.id
    json["user"]["event_notes"].count.should eq 0
  end

  it "GET users/profile; receives the logged in users profile, fails because of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    get_auth '/users/profile'

    response.status.should eq(403)
  end

  it "GET /users/profile/:id; attempts to view other user's profile, disabled at app level (23)" do
    create(:app_setting, app_setting_option_id: 23)

    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(403)
  end  

  it "GET /users/profile/:id; attempts to view other user's profile, disabled at app level (21)" do
    create(:app_setting, app_setting_option_id: 21)

    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(404)
  end

  it "GET /users/profile/:id; attempts to view other user's profile, disabled at user_role level (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user1.user_role)

    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(404)
  end

  it "GET /users/profile/:id; attempts to view other user's profile, disabled at user_role level (24)" do
    create(:app_setting, app_setting_option_id: 24, user_role: @user.user_role)

    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(403)
  end


  it "PUT users/profile; attempts to update active user's profile, fails, disabled at app level (21)" do
    create(:app_setting, app_setting_option_id: 21)

    put_auth '/users/profile', { user: { last_name: "UserTest" } }

    response.status.should eq(403)
  end

  it "GET users/profile; receives the logged in users profile, should return nil posts because of app setting (27)" do
    create(:app_setting, app_setting_option_id: 27)

    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["id"].should eq(@user.id)
    json["user"]['post_count'].should eq nil
  end  

  it "GET /users/profile/:id; another user's groups - not shown because User app_setting (18)" do
    create(:app_setting, app_setting_option_id: 18, user: @user1)
    secret_group = create(:group, :secret, name: 'XYZ Secret')
    create(:group_member, user: @user1, group: @group1)
    create(:group_member, user: @user1, group: @group2)
    create(:group_member, user: @user1, group: secret_group)

    get_auth "/users/profile/#{@user1.id}"
    
    json["user"]["id"].should eq @user1.id
    json["user"]["groups"].count.should eq 0
  end

  it "GET users/profile; receives the logged in users profile, should return nil likes because of app setting (30)" do
    create(:app_setting, app_setting_option_id: 30)
    
    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["id"].should eq(@user.id)
    json["user"][' "post_like_count"'].should eq nil
  end 

  it "GET users/profile; receives the logged in users profile, should return nil connections because of app setting (33)" do
    connection = create(:user_connection, :approved, sender_user: @user, recipient_user: @user2)
    create(:app_setting, app_setting_option_id: 33)
    
    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["id"].should eq(@user.id)
    json["user"]["user_connection_count"].should eq nil
  end  

  it "GET /users/profile/:id; other users profile - no messages - User app_setting (44)" do
    create(:app_setting, app_setting_option_id: 44, user_role: @user1.user_role)
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user1.email
    json["user"]["can_message"].should eq false
  end

  it "GET /users/profile/:id; other users profile - no messages - User app_setting (44)" do
    create(:app_setting, app_setting_option_id: 43, user_role: @user.user_role)
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user1.email
    json["user"]["can_message"].should eq false
  end

  it "GET /users/profile/:id; other users profile - no messages - User app_setting (46)" do
    create(:app_setting, app_setting_option_id: 46, user: @user1)
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eq(200)
    json["user"]["email"].should eq @user1.email
    json["user"]["can_message"].should eq false
  end

  it "GET users/profile; receives the logged in users profile, should return nil connections because of app setting (47)" do
    connection = create(:user_connection, :approved, sender_user: @user, recipient_user: @user2)
    create(:app_setting, app_setting_option_id: 47)
    
    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["id"].should eq(@user.id)
    json["user"]["user_connection_count"].should eq nil
  end

  it "GET users/profile; receives the logged in users profile, should return nil posts because of app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)
    
    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["id"].should eq(@user.id)
    json["user"]['post_count'].should eq nil
  end  
  
  it "GET users/profile; receives the logged in users profile, should return nil likes because of app setting (109)" do
    create(:app_setting, app_setting_option_id: 109)
    
    get_auth '/users/profile'

    response.status.should eq (200)
    json["user"]["id"].should eq(@user.id)
    json["user"]["post_like_count"].should eq nil
  end 

  it "GET /users/profile/:id; another user's attended events - can not view events not a part of user_role setting (136)" do
    create(:app_setting, app_setting_option_id: 136, user_role: @user.user_role)
    event1 = create(:event, :random, name: "123 Event One", begin_date: Date.today - 10.day, end_date: Date.today)
    event2 = create(:event, :random, name: "456 Event Two", begin_date: Date.today - 15.days, end_date: Date.today)
    create(:event_user, :attended, user: @user1, event: event1)
    create(:event_user, :attended, user: @user1, event: event2)
    create(:group_member, user: @user, group: event1.group)
    create(:group_member, user: @user, group: event2.group)
 
    get_auth "/users/profile/#{@user1.id}"

    json["user"]["id"].should eq @user1.id
    json["user"]['attended_events'].count.should eq 0
  end

  it "GET /user/profile/:id; even connections can't send messages, disabled at user level (45)" do
    create(:app_setting, app_setting_option_id: 45, user: @user1)
    create(:user_connection, is_approved: true, sender_user: @user1, recipient_user: @user)
    
    get_auth "/users/profile/#{@user1.id}"
    
    response.status.should eql(200)
    json["user"]["can_message"].should eq false
  end

end