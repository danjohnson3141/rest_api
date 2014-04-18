require 'spec_helper'

describe FeaturedPost do  

  before(:all) do
    @user = create(:user)

    @group_open = create(:group, :random, :open)
    @event_open = create(:event, :random, group: @group_open)
    
    @group_private = create(:group, :random, :private)
    @event_private = create(:event, :random, group: @group_private)
    
    @group_secret = create(:group, :random, :secret)
    @event_secret = create(:event, :random, group: @group_secret)

    @post_event_open1 = create(:post, :random, event: @event_open, created_at: Time.now - 10.minute)
    @post_event_open2 = create(:post, :random, event: @event_open, created_at: Time.now - 20.minute)
    @post_event_open3 = create(:post, :random, event: @event_open, created_at: Time.now - 30.minute)    

    @post_event_private1 = create(:post, :random, event: @event_private, created_at: Time.now - 10.minute)
    @post_event_private2 = create(:post, :random, event: @event_private, created_at: Time.now - 20.minute)
    @post_event_private3 = create(:post, :random, event: @event_private, created_at: Time.now - 30.minute)   

    @post_event_secret1 = create(:post, :random, event: @event_secret, created_at: Time.now - 10.minute)
    @post_event_secret2 = create(:post, :random, event: @event_secret, created_at: Time.now - 20.minute)
    @post_event_secret3 = create(:post, :random, event: @event_secret, created_at: Time.now - 30.minute)    

    @post_group_open1 = create(:post, :random, group: @group_open, created_at: Time.now - 10.minute)
    @post_group_open2 = create(:post, :random, group: @group_open, created_at: Time.now - 20.minute)
    @post_group_open3 = create(:post, :random, group: @group_open, created_at: Time.now - 30.minute)    

    @post_group_private1 = create(:post, :random, group: @group_private, created_at: Time.now - 10.minute)
    @post_group_private2 = create(:post, :random, group: @group_private, created_at: Time.now - 20.minute)
    @post_group_private3 = create(:post, :random, group: @group_private, created_at: Time.now - 30.minute)   

    @post_group_secret1 = create(:post, :random, group: @group_secret, created_at: Time.now - 10.minute)
    @post_group_secret2 = create(:post, :random, group: @group_secret, created_at: Time.now - 20.minute)
    @post_group_secret3 = create(:post, :random, group: @group_secret, created_at: Time.now - 30.minute)

    @featured_post_group_open1 = create(:featured_post, post: @post_group_open1, created_at: Time.now - 9.minute)
    @featured_post_group_open2 = create(:featured_post, post: @post_group_open2, created_at: Time.now - 8.minute)
    @featured_post_group_open3 = create(:featured_post, post: @post_group_open3, created_at: Time.now - 7.minute)    

    @featured_post_group_private1 = create(:featured_post, post: @post_group_private1, created_at: Time.now - 9.minute)
    @featured_post_group_private2 = create(:featured_post, post: @post_group_private2, created_at: Time.now - 8.minute)
    @featured_post_group_private3 = create(:featured_post, post: @post_group_private3, created_at: Time.now - 7.minute)    

    @featured_post_group_secret1 = create(:featured_post, post: @post_group_secret1, created_at: Time.now - 9.minute)
    @featured_post_group_secret2 = create(:featured_post, post: @post_group_secret2, created_at: Time.now - 8.minute)
    @featured_post_group_secret3 = create(:featured_post, post: @post_group_secret3, created_at: Time.now - 7.minute)    

    @featured_post_event_open1 = create(:featured_post, post: @post_event_open1, created_at: Time.now - 9.minute)
    @featured_post_event_open2 = create(:featured_post, post: @post_event_open2, created_at: Time.now - 8.minute)
    @featured_post_event_open3 = create(:featured_post, post: @post_event_open3, created_at: Time.now - 7.minute)    

    @featured_post_event_private1 = create(:featured_post, post: @post_event_private1, created_at: Time.now - 9.minute)
    @featured_post_event_private2 = create(:featured_post, post: @post_event_private2, created_at: Time.now - 8.minute)
    @featured_post_event_private3 = create(:featured_post, post: @post_event_private3, created_at: Time.now - 7.minute)    

    @featured_post_event_secret1 = create(:featured_post, post: @post_event_secret1, created_at: Time.now - 9.minute)
    @featured_post_event_secret2 = create(:featured_post, post: @post_event_secret2, created_at: Time.now - 8.minute)
    @featured_post_event_secret3 = create(:featured_post, post: @post_event_secret3, created_at: Time.now - 7.minute)
  end

  it "GET /featured_posts/event/:event_id; get 3 featured post records, sorted by created_at, max limit 3" do
    post_extra1 = create(:post, :random, event: @event_open)
    post_extra2 = create(:post, :random, event: @event_open)
    post_extra3 = create(:post, :random, event: @event_open)
    create(:featured_post, post: post_extra1, created_at: Time.now - 4.minute)
    create(:featured_post, post: post_extra2, created_at: Time.now - 3.minute)
    create(:featured_post, post: post_extra3, created_at: Time.now - 2.minute)

    get_auth "/featured_posts/event/#{@event_open.id}?limit=3"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq post_extra3.id
    json["featured_posts"][1]["post"]["id"].should eq post_extra2.id
    json["featured_posts"][2]["post"]["id"].should eq post_extra1.id
  end

  it "GET /featured_posts/event/:event_id; returns featured posts, open event" do
    get_auth "/featured_posts/event/#{@event_open.id}"
    
    response.status.should eql(200)
   
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_event_open3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_event_open2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_event_open1.id
  end  

  it "GET /featured_posts/event/:event_id; returns featured posts, private event; is member, not user" do
    member = create(:group_member, user: @user, group: @group_private)

    get_auth "/featured_posts/event/#{@event_private.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_event_private3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_event_private2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_event_private1.id
  end  

  it "GET /featured_posts/event/:event_id; returns featured posts, private event; is user, not member" do
    event_user = create(:event_user, user: @user, event: @event_private)

    get_auth "/featured_posts/event/#{@event_private.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_event_private3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_event_private2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_event_private1.id
  end    

  it "GET /featured_posts/event/:event_id; returns featured posts, secret event; is member, not user" do
    member = create(:group_member, user: @user, group: @group_secret)

    get_auth "/featured_posts/event/#{@event_secret.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_event_secret3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_event_secret2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_event_secret1.id
  end  

  it "GET /featured_posts/event/:event_id; returns featured posts, secret event; is user, not member" do
    event_user = create(:event_user, user: @user, event: @event_secret)

    get_auth "/featured_posts/event/#{@event_secret.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_event_secret3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_event_secret2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_event_secret1.id
  end  
 

  it "GET /featured_posts/event/:event_id; get 0 featured post records, other events have featured posts but not this one" do
    other_open_event = create(:event, :random, group: @group_open)
    post_extra1 = create(:post, :random, event: other_open_event)
    post_extra2 = create(:post, :random, event: other_open_event)

    get_auth "/featured_posts/event/#{other_open_event.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(0)
  end

  it "GET /featured_posts/group/:group_id; get 3 featured post records, sorted by created_at, max limit 3" do
    post_extra1 = create(:post, :random, group: @group_open)
    post_extra2 = create(:post, :random, group: @group_open)
    post_extra3 = create(:post, :random, group: @group_open)
    create(:featured_post, post: post_extra1, created_at: Time.now - 4.minute)
    create(:featured_post, post: post_extra2, created_at: Time.now - 3.minute)
    create(:featured_post, post: post_extra3, created_at: Time.now - 2.minute)

    get_auth "/featured_posts/group/#{@group_open.id}?limit=3"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq post_extra3.id
    json["featured_posts"][1]["post"]["id"].should eq post_extra2.id
    json["featured_posts"][2]["post"]["id"].should eq post_extra1.id
  end

  it "GET /featured_posts/group/:group_id; returns featured posts, private group; is member, not user" do
    member = create(:group_member, user: @user, group: @group_private)

    get_auth "/featured_posts/group/#{@group_private.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_group_private3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_group_private2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_group_private1.id
  end  
   
  it "GET /featured_posts/group/:group_id; returns featured posts, secret group; is member, not user" do
    member = create(:group_member, user: @user, group: @group_secret)

    get_auth "/featured_posts/group/#{@group_secret.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(3)
    json["featured_posts"][0]["post"]["id"].should eq @post_group_secret3.id
    json["featured_posts"][1]["post"]["id"].should eq @post_group_secret2.id
    json["featured_posts"][2]["post"]["id"].should eq @post_group_secret1.id
  end  

  it "GET /featured_posts/event/:event_id; get 0 featured post records for secret event, not member, not user" do
    get_auth "/featured_posts/event/#{@event_secret.id}"
    
    response.status.should eql(404)
  end

  it "GET /featured_posts/event/:event_id; get 0 featured post records for private event, not member, not user" do
    get_auth "/featured_posts/event/#{@event_private.id}"
    
    response.status.should eql(404)
  end

  it "GET /featured_posts/:event_id; get a 404 status when using invalid event" do
    get_auth "/featured_posts/event/0"
    
    response.status.should eql(404)  
  end

  it "GET /featured_posts/group/:group_id; get 0 featured post records, other groups have featured posts but not this one" do
    other_open_group = create(:group, :random, :open)

    get_auth "/featured_posts/group/#{other_open_group.id}"
    
    response.status.should eql(200)
    json['featured_posts'].count.should eq(0)
  end

  it "GET /featured_posts/group/:group_id; get 0 featured post records for private group, not member" do
    get_auth "/featured_posts/group/#{@group_private.id}"
    
    response.status.should eql(403)
  end

  it "GET /featured_posts/group/:group_id; get 0 featured post records for secret group, not member" do
    get_auth "/featured_posts/group/#{@group_secret.id}"
    
    response.status.should eql(404)
  end

  it "GET /featured_posts/group/:group_id; get 0 featured post records, group has posts but not featured" do
    clean_group = create(:group, :random, :open)
    clean_post = create(:post, :random, group: clean_group)

    get_auth "/featured_posts/group/#{clean_group.id}"
    
    response.status.should eql(200)

    json['featured_posts'].count.should eq(0)
  end

  it "GET /featured_posts/:group_id; get a 404 status when using invalid group" do
    get_auth "/featured_posts/group/0"
    
    response.status.should eql(404)  
  end

end