require 'spec_helper'

describe 'Posts' do

  before(:all) do
    @user = create(:user)
    @author = create(:user, :random, title: "Author")
    @group = create(:group, :random)
    @event = create(:event, :random)
  end

  it "GET /posts/user/:user_id; get all current users's posts" do
    create(:post, event: @event, creator: @user)
    create(:post, group: @group, creator: @user)

    get_auth "/posts/user/#{@user.id}"

    response.status.should eq(200)
    json["posts"].count.should eq(2)
  end

  it "GET /posts/user/:user_id; denied access to users's posts" do
    user1 = create(:user, :random)
    create(:post, event: @event, creator: user1)
    create(:post, group: @group, creator: user1)
    create(:app_setting, app_setting_option_id: 29, user: user1)

    get_auth "/posts/user/#{user1.id}"
    response.status.should eq(403)
  end

  # Again seems weerd but this is the way it is suppossed to behave
  it "GET /posts/user/:user_id; denied access to your own post list" do
    create(:post, event: @event, creator: @user)
    create(:post, group: @group, creator: @user)
    create(:app_setting, app_setting_option_id: 29, user: @user)

    get_auth "/posts/user/#{@user.id}"
    response.status.should eq(403)
  end

  it "GET /posts/user/:user_id; get all posts for another user, current user doesn't belong to private and secret group, they will not receive those posts" do
    private_group = create(:group, :private)
    secret_group = create(:group, :secret)
    create(:post, event: @event, creator: @author)
    create(:post, group: @group, creator: @author)
    create(:post, body: 'private', group: private_group, creator: @author)
    create(:post, body: 'secret', group: secret_group, creator: @author)

    get_auth "/posts/user/#{@author.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(2)
    json.to_s.should_not include('private', 'secret')
  end

  it "GET /posts/user/:user_id; get all posts for current user, current user doesn't belong to private and secret group, they will receive those posts" do
    private_group = create(:group, :private)
    secret_group = create(:group, :secret)
    create(:post, event: @event, creator: @user)
    create(:post, group: @group, creator: @user)
    create(:post, body: 'private', group: private_group, creator: @user)
    create(:post, body: 'secret', group: secret_group, creator: @user)

    get_auth "/posts/user/#{@user.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(4)
    json.to_s.should include('private', 'secret')
  end

  it "GET /posts/user/:user_id; get all posts for another user, current user belongs to private and secret group, they will receive those posts" do
    private_group = create(:group, :private)
    secret_group = create(:group, :secret)
    create(:group_member, user: @user, group: private_group)
    create(:group_member, user: @user, group: secret_group)
    create(:post, event: @event, creator: @author)
    create(:post, group: @group, creator: @author)
    create(:post, excerpt: 'private', group: private_group, creator: @author)
    create(:post, excerpt: 'secret', group: secret_group, creator: @author)

    get_auth "/posts/user/#{@author.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(4)
    json.to_s.should include('private', 'secret')
  end

  it "GET /posts/user/:user_id; get all posts for another user, current user doesn't belong to event's group, they will not receive those posts" do
    cfo_group = create(:group, :secret, name: 'CFO Group')
    cio_group = create(:group, :secret, name: 'CIO Group')
    cfo_event = create(:event, :random, group: cfo_group)
    cio_event = create(:event, :random, group: cio_group)
    create(:group_member, user: @user, group: cio_group)
    create(:post, excerpt: 'CIO', event: cio_event, creator: @author)
    create(:post, excerpt: 'CFO WTF?', event: cfo_event, creator: @author)
    create(:post, excerpt: 'CFO Chief Funky Officer', group: cfo_group, creator: @author)

    get_auth "/posts/user/#{@author.id}"
    
    response.status.should eq(200)
    json["posts"].count.should eq(1)
    json.to_s.should include('CIO')
  end

  it "GET /posts/user/:id; get a 404 status when using invalid user id" do
    get_auth "/posts/user/0"

    response.status.should eq(404)
  end

  it "GET /posts/user/:user_id; looks for posts in a private group" do
    user2 = create(:user, :random)
    private_group = create(:group, :private)
    group_member1 = create(:group_member, group: @group, user: @user)
    group_member2 = create(:group_member, group: @group, user: user2)
    group_member3 = create(:group_member, group: private_group, user: user2)
    public_post = create(:post, group: @group, creator: user2, body: 'private')
    private_post = create(:post, group: private_group, creator: user2, body: 'private')

    get_auth "/posts/user/#{user2.id}"

    response.status.should eq(200)
    json["posts"].count.should eq(1)
  end

  it "GET /posts/user/:user_id; get all posts for another user, current user doesn't belong to private and secret group, they will not receive those posts" do
    private_group = create(:group, :private)
    secret_group = create(:group, :secret)
    create(:post, event: @event, creator: @author)
    create(:post, group: @group, creator: @author)
    create(:post, body: 'private', group: private_group, creator: @author)
    create(:post, body: 'secret', group: secret_group, creator: @author)

    get_auth "/posts/user/#{@author.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(2)
    json.to_s.should_not include('private', 'secret')
  end

  it "GET /posts/user/:user_id; - Other members posts - open groups" do
    other_user = create(:user, :random, title: "Other User")
    event_post1 = create(:post, event: @event, creator: other_user)
    event_post2 = create(:post, event: @event, creator: other_user)
    event_post3 = create(:post, event: @event, creator: other_user)
    group_post1 = create(:post, group: @group, creator: other_user)
    group_post2 = create(:post, group: @group, creator: other_user)
    group_post3 = create(:post, group: @group, creator: other_user)

    get_auth "/posts/user/#{other_user.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(6)
  end

  it "GET /posts/user/:user_id; - Other members posts - private groups" do
    other_user = create(:user, :random, title: "Other User")
    private_group = create(:group, :private)
    event_private = create(:event, name: "private", group: private_group)

    event_post1 = create(:post, event: event_private, creator: other_user)
    event_post2 = create(:post, event: event_private, creator: other_user)
    event_post3 = create(:post, event: event_private, creator: other_user)
    group_post1 = create(:post, group: private_group, creator: other_user)
    group_post2 = create(:post, group: private_group, creator: other_user)
    group_post3 = create(:post, group: private_group, creator: other_user)

    get_auth "/posts/user/#{other_user.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(0)
  end

  it "GET /posts/user/:user_id; - Other members posts - private groups and event user" do
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

    get_auth "/posts/user/#{other_user.id}"
    response.status.should eq(200)
    json["posts"].count.should eq(3)
  end

end