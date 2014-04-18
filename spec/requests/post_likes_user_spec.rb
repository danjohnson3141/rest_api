require 'spec_helper'

describe 'PostsLikes' do

  before(:all) do
    @user = create(:user)
    @user1 =  create(:user, :random, first_name: "AAA", last_name: "AAA")
    @user2 =  create(:user, :random, first_name: "BBB", last_name: "AAA")
    @user3 =  create(:user, :random, first_name: "CCC", last_name: "CCC")
    @user_author = create(:user, :random, title: "Author", first_name: "Stephen", last_name: "King")

    @group_open = create(:group, :random, :open)
    @group_private = create(:group, :random, :private)
    @group_secret = create(:group, :random, :secret)
    
    @event_open = create(:event, :random, group: @group_open)
    @event_private = create(:event, :random, group: @group_private)
    @event_secret = create(:event, :random, group: @group_secret)
    
    @post_event_open = create(:post, event: @event_open, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    @post_event_private = create(:post, event: @event_private, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    @post_event_secret = create(:post, event: @event_secret, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    
    @post_group_open = create(:post, group: @group_open, title: "This Is The Title, Group Post", excerpt: 'User Definced Excerpt', body: 'Body of the Group Post', creator: @user_author)
    @post_group_private = create(:post, group: @group_private, title: "This Is The Title, Group Post", excerpt: 'User Definced Excerpt', body: 'Body of the Group Post', creator: @user_author)
    @post_group_secret = create(:post, group: @group_secret, title: "This Is The Title, Group Post", excerpt: 'User Definced Excerpt', body: 'Body of the Group Post', creator: @user_author)

    @like_post_event_open1    = create(:post_like, post: @post_event_open, user: @user)   
    @like_post_event_open2    = create(:post_like, post: @post_event_open, user: @user1)   
    @like_post_event_private1 = create(:post_like, post: @post_event_private, user: @user)
    @like_post_event_private2 = create(:post_like, post: @post_event_private, user: @user1)
    @like_post_event_secret1  = create(:post_like, post: @post_event_secret, user: @user) 
    @like_post_event_secret2  = create(:post_like, post: @post_event_secret, user: @user1) 
    @like_post_group_open1    = create(:post_like, post: @post_group_open, user: @user)   
    @like_post_group_open2    = create(:post_like, post: @post_group_open, user: @user1)   
    @like_post_group_private1 = create(:post_like, post: @post_group_private, user: @user)
    @like_post_group_private2 = create(:post_like, post: @post_group_private, user: @user1)
    @like_post_group_secret1  = create(:post_like, post: @post_group_secret, user: @user) 
    @like_post_group_secret2  = create(:post_like, post: @post_group_secret, user: @user1) 
  end

  it "GET /post_likes/users/:post_id; checks on post in secret group, not member, should 404" do
    get_auth "/post_likes/users/#{@post_group_secret.id}"
    
    response.status.should eql(404)
  end    

  xit "GET /post_likes/users/:post_id; checks sort order" do
    like2 = create(:post_like, post: @post_group_open, user: @user2)
    like3 = create(:post_like, post: @post_group_open, user: @user3)
    like4 = create(:post_like, post: @post_group_open, user: @user_author)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    
    response.status.should eql(200)
    json["post_likes"].count.should eq 5
    json["post_likes"][0]["user"]["id"].should eq @user1.id
    json["post_likes"][1]["user"]["id"].should eq @user2.id
    json["post_likes"][2]["user"]["id"].should eq @user3.id
    json["post_likes"][3]["user"]["id"].should eq @user_author.id
    json["post_likes"][4]["user"]["id"].should eq @user.id

  end  

  it "GET /post_likes/users/:post_id; checks on post in secret group, is member, returns post" do
    create(:group_member, user: @user, group: @group_secret)

    get_auth "/post_likes/users/#{@post_group_secret.id}"

    response.status.should eql(200)
    json["post_likes"].first["id"].should eq @like_post_group_secret1.id
  end

  it "GET /post_likes/users/:post_id; checks on post in secret event, not member, not user, should 404" do
    get_auth "/post_likes/users/#{@post_event_secret.id}"

    response.status.should eql(404)
  end    

  xit "GET /post_likes/users/:post_id; checks on post in secret event, is member, not user, returns post" do
    member = create(:group_member, user: @user, group: @group_secret)
    
    get_auth "/post_likes/users/#{@post_event_secret.id}"

    response.status.should eql(200)
    json["post_likes"].first["id"].should eq @like_post_event_secret2.id
  end   

  xit "GET /post_likes/users/:post_id; checks on post of secret event, not member, is user, returns post" do
    event_user = create(:event_user, event: @event_secret, user: @user)

    get_auth "/post_likes/users/#{@post_event_secret.id}"

    response.status.should eql(200)
    json["post_likes"].first["id"].should eq @like_post_event_secret2.id
  end

  it "GET /post_likes/users/:post_id; checks on post in private group, not member, should 404" do
    get_auth "/post_likes/users/#{@post_group_private.id}"

    response.status.should eql(404)
  end  

  xit "GET /post_likes/users/:post_id; checks on post in private group, is member, returns post" do
    member = create(:group_member, user: @user, group: @group_private)

    get_auth "/post_likes/users/#{@post_group_private.id}"

    response.status.should eql(200)
    json["post_likes"].first["id"].should eq @like_post_group_private2.id
  end

  it "GET /post_likes/users/:post_id; checks on post in private event, not member, not user, should 404" do
    get_auth "/post_likes/users/#{@post_event_private.id}"

    response.status.should eql(404)
  end    

  xit "GET /post_likes/users/:post_id; checks on post in private event, is member, not user, returns post" do
    member = create(:group_member, user: @user, group: @group_private)

    get_auth "/post_likes/users/#{@post_event_private.id}"

    response.status.should eql(200)
    json["post_likes"].first["id"].should eq @like_post_event_private2.id
  end   

  xit "GET /post_likes/users/:post_id; checks on post of private event, not member, is user, returns post" do
    private_event_user = create(:event_user, event: @event_private, user: @user)

    get_auth "/post_likes/users/#{@post_event_private.id}"

    response.status.should eql(200)
    json["post_likes"].first["id"].should eq @like_post_event_private2.id
  end  

  it "GET /post_likes/users/:post_id; get all post likes for a post, post has no likes, nothing returned" do
    clean_post = create(:post, :random, group: @group_open)

    get_auth "/post_likes/users/#{clean_post.id}"
    
    response.status.should eq 200
    json['post_likes'].count.should eq 0
  end

  it "GET /post_likes/users/:post_id; get a 404 status when using invalid post id" do
    get_auth "/post_likes/users/0"
    
    response.status.should eq 404
  end

  it "GET /post_likes/users/:post_id; get a 403 because likes are turned off at App level" do
    create(:app_setting, app_setting_option_id: 109)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    response.status.should eq 403
  end

  it "GET /post_likes/users/:post_id; get a 403 because likes are turned off at UserRole level" do
    create(:app_setting, app_setting_option_id: 112, user_role: @user.user_role)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    response.status.should eq 403
  end

  it "GET /post_likes/users/:post_id; get a 403 because likes are turned off at UserRole level" do
    create(:app_setting, app_setting_option_id: 112, user_role: @user.user_role)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    response.status.should eq 403
  end  

  it "GET /post_likes/users/:post_id; attempts to receive likes list, turned off at app setting (113)" do
    create(:app_setting, app_setting_option_id: 113)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    response.status.should eq 403
  end

  it "GET /post_likes/users/:post_id; post_like users on a post filtered by user app_setting" do
    create(:app_setting, app_setting_option_id: 114, user_role: @user.user_role)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    response.status.should eq 403
  end

  xit "GET /post_likes/users/:post_id; post_like users on a post; check post like order; check connection status" do
    like2 = create(:post_like, post: @post_group_open, user: @user2)
    like3 = create(:post_like, post: @post_group_open, user: @user3)
    like4 = create(:post_like, post: @post_group_open, user: @user_author)
    user_connection1 = create(:user_connection, :approved, sender_user: @user, recipient_user: @user2)
    user_connection2 = create(:user_connection, :pending, sender_user: @user, recipient_user: @user1)
    create(:app_setting, app_setting_option_id: 50, user: @user3)

    get_auth "/post_likes/users/#{@post_group_open.id}"
    response.status.should eq 200
    json["post_likes"].count.should eq 5
    json["post_likes"][0]["user"]["id"].should eq @user1.id
    json["post_likes"][0]["user"]["connection_status"]["id"].should eq user_connection2.id
    json["post_likes"][0]["user"]["connection_status"]["is_approved"].should eq false
    json["post_likes"][0]["user"]["connection_status"]["is_approver"].should eq false
    json["post_likes"][0]["user"]["user_connections_blocked"].should eq false
    json["post_likes"][1]["user"]["id"].should eq @user2.id
    json["post_likes"][1]["user"]["connection_status"]["id"].should eq user_connection1.id
    json["post_likes"][3]["user"]["connection_status"]["is_approved"].should eq true
    json["post_likes"][1]["user"]["connection_status"].should eq nil
    json["post_likes"][1]["user"]["user_connections_blocked"].should eq false
    json["post_likes"][2]["user"]["id"].should eq @user3.id
    json["post_likes"][2]["user"]["connection_status"].should eq nil
    json["post_likes"][2]["user"]["user_connections_blocked"].should eq true
    json["post_likes"][3]["user"]["id"].should eq @user_author.id
    json["post_likes"][3]["user"]["connection_status"]["is_approver"].should eq false
    json["post_likes"][3]["user"]["user_connections_blocked"].should eq false
    json["post_likes"][4]["user"]["id"].should eq @user.id
    json["post_likes"][4]["user"]["connection_status"].should eq nil
    json["post_likes"][4]["user"]["user_connections_blocked"].should eq false
  end

end