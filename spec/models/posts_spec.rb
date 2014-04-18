require 'spec_helper'

describe 'Post' do

  before(:all) do
    @user = create(:user, :random)
    @author = create(:user, :random)
    @event = create(:event, :random)
    @event_session = create(:event_session, :random, event: @event)
    @group = create(:group, :random)
  end

  it "A post created with a body, event, and creator is valid" do
    Post.create(body: 'test', event: @event, creator: @author).valid?.should eq true
  end

  it "A post created with a body, group, and creator is valid" do
    Post.create(body: 'test', group: @group, creator: @author).valid?.should eq true
  end
  
  it "A post created with a body, event_session, and creator is valid" do
    Post.create(body: 'test', event_session: @event_session, creator: @author).valid?.should eq true
  end

  it "A post created with a group and event is invalid" do
    Post.create(body: 'test', group: @group, creator: @author, event: @event).valid?.should eq false
  end

  it "A post created with a group and event_session is invalid" do
    Post.create(body: 'test', group: @group, creator: @author, event_session: @event_session).valid?.should eq false
  end

  it "A post created with an event and event_session is invalid" do
    Post.create(body: 'test', event: @event, creator: @author, event_session: @event_session).valid?.should eq false
  end

  it "A post created with a group, event, and event_session is invalid" do
    Post.create(body: 'test', event: @event, group: @group, creator: @author, event_session: @event_session).valid?.should eq false
  end

  it "A post created without a body is invalid" do
    Post.create(group: @group, creator: @author).valid?.should eq false
  end

  it "A post created without a group or event or event_session is invalid" do
    Post.create(body: 'test', creator: @author).valid?.should eq false
  end

  it "A post created with a group, but without an author is invalid" do
    Post.create(body: 'test', group: @group).valid?.should eq false
  end

  it "A post created with an event, but without an author is invalid" do
    Post.create(body: 'test', event: @event).valid?.should eq false
  end

  it "A post created with an event_session, but without an author is invalid" do
    Post.create(body: 'test', event_session: @event_session).valid?.should eq false
  end

  it "Deleting an event post will delete all dependencies" do
    post = Post.create(body: 'test', event: @event, creator: @author)
    PostLike.create(post: post, user: @user)
    PostAttachment.create(post: post, url: 'www.attachment.com/attachment.jpg')
    FeaturedPost.create(post: post)
    PostContributor.create(post: post, user: @user)
    PostComment.create(post: post, user: @user, body: 'Nice post!')
    PostFollower.create(post: post, user: @user)
    Post.find(post.id).destroy
    PostComment.count.should eq 0
    PostLike.count.should eq 0
  end

end
