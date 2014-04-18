require 'spec_helper'

describe 'PostsLikes' do

  before(:all) do
    @user   = create(:user)
    @user2  = create(:user, :random)
    @user3  = create(:user, :random)
    @author = create(:user, :random, title: "Author")
    @event = create(:event, :random)    
    
    @group_private1  = create(:group, :random, :private, name: 'group_private1' )
    @group_private2  = create(:group, :random, :private, name: 'group_private2' )
    @group_public1   = create(:group, :random, :open   , name: 'group_public1 ' )
    @group_public2   = create(:group, :random, :open   , name: 'group_public2 ' )
    @group_secret1   = create(:group, :random, :secret , name: 'group_secret1 ' )
    @group_secret2   = create(:group, :random, :secret , name: 'group_secret2 ' )

    @group_member1 = create(:group_member, group: @group_private1, user: @author)    
    @group_member2 = create(:group_member, group: @group_private2, user: @author) 
    @group_member3 = create(:group_member, group: @group_public1,  user: @author)    
    @group_member4 = create(:group_member, group: @group_public2,  user: @author) 
    @group_member5 = create(:group_member, group: @group_secret1,  user: @author)    
    @group_member6 = create(:group_member, group: @group_secret2,  user: @author) 
    @group_member7 = create(:group_member, group: @group_private1, user: @user) 
    @group_member8 = create(:group_member, group: @group_secret1,  user: @user)     
    @group_member9 = create(:group_member, group: @group_public1,  user: @user)  

    @post1 = create(:post, :random, creator: @author, body: 'group_public1 ', group: @group_public1 )
    @post2 = create(:post, :random, creator: @author, body: 'group_public2 ', group: @group_public2 )
    @post3 = create(:post, :random, creator: @author, body: 'group_private1', group: @group_private1 )
    @post4 = create(:post, :random, creator: @author, body: 'group_private2', group: @group_private2 )
    @post5 = create(:post, :random, creator: @author, body: 'group_secret1 ', group: @group_secret1 )
    @post6 = create(:post, :random, creator: @author, body: 'group_secret2 ', group: @group_secret2 )

    @post_like01 = create(:post_like, post: @post1, user: @user2, created_at: Time.now - 5.minutes)
    @post_like02 = create(:post_like, post: @post2, user: @user2, created_at: Time.now - 7.minutes)
    @post_like03 = create(:post_like, post: @post3, user: @user2, created_at: Time.now - 2.minutes)
    @post_like04 = create(:post_like, post: @post4, user: @user2, created_at: Time.now - 4.minutes)
    @post_like05 = create(:post_like, post: @post5, user: @user2, created_at: Time.now - 8.minutes)
    @post_like06 = create(:post_like, post: @post6, user: @user2, created_at: Time.now - 11.minutes)
    @post_like07 = create(:post_like, post: @post1, user: @user3, created_at: Time.now - 1.minutes)
    @post_like08 = create(:post_like, post: @post2, user: @user3, created_at: Time.now - 3.minutes)
    @post_like09 = create(:post_like, post: @post3, user: @user3, created_at: Time.now - 10.minutes)
    @post_like10 = create(:post_like, post: @post4, user: @user3, created_at: Time.now - 12.minutes)
    @post_like11 = create(:post_like, post: @post5, user: @user3, created_at: Time.now - 9.minutes)
    @post_like12 = create(:post_like, post: @post6, user: @user3, created_at: Time.now - 6.minutes)
  end 

  it "GET /post_likes/posts/:user_id; returns 4 likes, 2 from public groups, 1 from private, 1 from secret" do
    get_auth "/post_likes/posts/#{@user2.id}"

    response.status.should eq 200
    json['post_likes'].count.should eq 4
  end

  it "GET /post_likes/posts/:user_id; returns 6 likes, sorts by created_at date" do
    group_member10 = create(:group_member, group: @group_private2 , user: @user) 
    group_member11 = create(:group_member, group: @group_secret2 , user: @user)     
    group_member12 = create(:group_member, group: @group_public2 , user: @user)  

    get_auth "/post_likes/posts/#{@user2.id}"
    
    response.status.should eq 200
    json['post_likes'].count.should eq 6
    json['post_likes'][0]["id"].should eq @post_like03.id
    json['post_likes'][1]["id"].should eq @post_like04.id
    json['post_likes'][2]["id"].should eq @post_like01.id
    json['post_likes'][3]["id"].should eq @post_like02.id
    json['post_likes'][4]["id"].should eq @post_like05.id
    json['post_likes'][5]["id"].should eq @post_like06.id
  end

  it "GET /post_likes/posts/:user_id; returns 6 likes, for current_user" do
    private_group1 = create(:group, :private, name: "private_group1")
    private_group2 = create(:group, :private, name: "private_group2")
    event_private = create(:event, name: "private", group: private_group2)

    create(:event_user, user: @user, event: event_private)
  
    event_post1 = create(:post, event: event_private, creator: @user)
    event_post2 = create(:post, event: event_private, creator: @user)
    event_post3 = create(:post, event: event_private, creator: @user)
    group_post1 = create(:post, group: private_group1, creator: @user)
    group_post2 = create(:post, group: private_group1, creator: @user)
    group_post3 = create(:post, group: private_group1, creator: @user)

    create(:post_like, post: event_post1, user: @user)
    create(:post_like, post: event_post2, user: @user)
    create(:post_like, post: event_post3, user: @user)
    create(:post_like, post: group_post1, user: @user)
    create(:post_like, post: group_post2, user: @user)
    create(:post_like, post: group_post3, user: @user)

    get_auth "/post_likes/posts/#{@user.id}"
    
    response.status.should eq 200
    json['post_likes'].count.should eq 6
  end

  it "GET /post_likes/posts/:user_id; post_like posts a user has liked; blocked" do
    create(:app_setting, app_setting_option_id: 32, user: @user2)

    get_auth "/post_likes/posts/#{@user2.id}"
    response.status.should eq 403
  end

  it "GET /post_likes/posts/:user_id; post_like posts a user has liked; blocked" do
    create(:app_setting, app_setting_option_id: 24, user_role: @user.user_role)

    get_auth "/post_likes/posts/#{@user2.id}"
    response.status.should eq 403
  end

  it "GET /post_likes/posts/:user_id; - Other members post likes - open groups" do
    other_user = create(:user, :random, title: "Other User")
    event_post1 = create(:post, event: @event, creator: other_user)
    event_post2 = create(:post, event: @event, creator: other_user)
    event_post3 = create(:post, event: @event, creator: other_user)
    group_post1 = create(:post, group: @group_public1, creator: other_user)
    group_post2 = create(:post, group: @group_public1, creator: other_user)
    group_post3 = create(:post, group: @group_public1, creator: other_user)

    create(:post_like, post: event_post1, user: other_user)
    create(:post_like, post: event_post2, user: other_user)
    create(:post_like, post: event_post3, user: other_user)
    create(:post_like, post: group_post1, user: other_user)
    create(:post_like, post: group_post2, user: other_user)
    create(:post_like, post: group_post3, user: other_user)

    get_auth "/post_likes/posts/#{other_user.id}"
    response.status.should eq(200)
    json["post_likes"].count.should eq(6)
  end

  it "GET /post_likes/posts/:user_id; - Other members post likes - private groups" do
    other_user = create(:user, :random, title: "Other User")
    private_group = create(:group, :private)
    event_private = create(:event, name: "private", group: private_group)

    event_post1 = create(:post, event: event_private, creator: other_user)
    event_post2 = create(:post, event: event_private, creator: other_user)
    event_post3 = create(:post, event: event_private, creator: other_user)
    group_post1 = create(:post, group: private_group, creator: other_user)
    group_post2 = create(:post, group: private_group, creator: other_user)
    group_post3 = create(:post, group: private_group, creator: other_user)

    create(:post_like, post: event_post1, user: other_user)
    create(:post_like, post: event_post2, user: other_user)
    create(:post_like, post: event_post3, user: other_user)
    create(:post_like, post: group_post1, user: other_user)
    create(:post_like, post: group_post2, user: other_user)
    create(:post_like, post: group_post3, user: other_user)

    get_auth "/post_likes/posts/#{other_user.id}"
    response.status.should eq(200)
    json["post_likes"].count.should eq(0)
  end

  it "GET /post_likes/posts/:user_id; - Other members post likes - private groups and event user" do
    other_user = create(:user, :random, title: "Other User")
    private_group1 = create(:group, :private, name: "private_group1")
    private_group2 = create(:group, :private, name: "private_group2")
    event_private = create(:event, name: "private", group: private_group2)

    create(:event_user, user: @user, event: event_private)

    event_post1 = create(:post, event: event_private, creator: other_user)
    event_post2 = create(:post, event: event_private, creator: other_user)
    event_post3 = create(:post, event: event_private, creator: other_user)
    group_post1 = create(:post, group: private_group1, creator: other_user)
    group_post2 = create(:post, group: private_group1, creator: other_user)
    group_post3 = create(:post, group: private_group1, creator: other_user)

    create(:post_like, post: event_post1, user: other_user)
    create(:post_like, post: event_post2, user: other_user)
    create(:post_like, post: event_post3, user: other_user)
    create(:post_like, post: group_post1, user: other_user)
    create(:post_like, post: group_post2, user: other_user)
    create(:post_like, post: group_post3, user: other_user)

    get_auth "/post_likes/posts/#{other_user.id}"
    response.status.should eq(200)
    json["post_likes"].count.should eq(3)
  end

end