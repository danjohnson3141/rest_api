require 'spec_helper'

describe 'PostsEvent' do

  before(:all) do
    @user = create(:user)
    @event = create(:event, :random)
  end


  it "GET /posts/event/:event_id; returns event session post. Author should be speaker(s). Event session id should be returned." do
    event_speaker_user = create(:user, :random)
    author = create(:user, :random)
    event_session = create(:event_session, name: "Session Name", description: "Session Description", event: @event)
    post = create(:post, event_session: event_session, title: "this is the post title", excerpt: 'my own excerpt', body: 'This is the body of the post', creator: author)
    event_speaker = create(:event_speaker, first_name: event_speaker_user.first_name, last_name: event_speaker_user.last_name, event_session: event_session, user: event_speaker_user)

    get_auth "/posts/event/#{@event.id}"

    response.status.should eql(200)
    json["posts"].first["excerpt"].should eq post.excerpt
    json["posts"].first["title"].should eq post.title
    json["posts"].first["authors"].first["id"].should eq event_speaker_user.id
    json["posts"].first["authors"].first["first_name"].should eq event_speaker_user.first_name
    json["posts"].first["authors"].first["last_name"].should eq event_speaker_user.last_name
    json["posts"].first["authors"].first["photo"].should eq event_speaker_user.photo
    json["posts"].first["event_session"]["id"].should eq event_session.id
    json["posts"].first["event_session"]["event"]["id"].should eq event_session.event.id
  end

  it "GET /posts/event/:id; checks on post in secret event, not member, not user, should 404" do
    secret_group = create(:group, :secret)
    secret_event = create(:event, :random, group: secret_group)
    secret_post = create(:post, event: secret_event)

    get_auth "/posts/event/#{secret_event.id}"

    response.status.should eql(404)
  end  

  it "GET /posts/event/:event_id; checks on post in secret event, not member, not user, should 404" do
    secret_group = create(:group, :secret)
    secret_event = create(:event, :random, group: secret_group)
    secret_user = create(:event_user, event: secret_event, user: @user)
    secret_session = create(:event_session, :random, event: secret_event)
    secret_post = create(:post, :random, event_session: secret_session)

    get_auth "/posts/event/#{secret_event.id}"

    response.status.should eql(200)
    json["posts"][0]["id"].should eq secret_post.id
  end

  it "GET /posts/event/:event_id; checks on post in open event, is member, not user, returns post" do
    post = create(:post, :event)
    member = create(:group_member, user: @user, group: post.event.group)

    get_auth "/posts/event/#{post.event.id}"

    response.status.should eql(200)
    json["posts"].first["id"].should eq post.id
  end

  it "GET /posts/event/:id; checks on post in secret event, is member, not user, returns post" do
    secret_group = create(:group, :secret, :random)
    secret_event = create(:event, :random, group: secret_group)
    secret_post = create(:post, event: secret_event)
    secret_member = create(:group_member, user: @user, group: secret_group)

    get_auth "/posts/event/#{secret_event.id}"

    response.status.should eql(200)
    json["posts"].first["id"].should eq secret_post.id
  end

  it "GET /posts/event/:event_id; checks on post of secret event, not member, is user, returns post" do
    secret_group = create(:group, :secret)
    secret_event = create(:event, :random, group: secret_group)
    secret_post = create(:post, event: secret_event)
    secret_event_user = create(:event_user, user: @user, event: secret_event)

    get_auth "/posts/event/#{secret_event.id}"

    response.status.should eql(200)
    json["posts"].first["id"].should eq secret_post.id
  end

  it "GET /posts/event/:event_id; get a 404 status when using invalid event id" do
    get_auth "/posts/event/0"
    response.status.should eql(404)
  end

end