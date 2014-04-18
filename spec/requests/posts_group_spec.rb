require 'spec_helper'

describe 'PostsGroups' do

  before(:all) do
    @user = create(:user)
    @author = create(:user, :random)
    @open_group = create(:group, :open)
  end

  def create_post_for_sort_test
    @post = []
    @post[1] = create(:post, title: "2014-03-15 08:00:00", group: @open_group, creator: @author, created_at: '2014-03-15 08:00:00') # third
    @post[2] = create(:post, title: "2014-03-15 09:00:00", group: @open_group, creator: @author, created_at: '2014-03-15 09:00:00') # second
    @post[3] = create(:post, title: "2014-03-15 10:00:00", group: @open_group, creator: @author, created_at: '2014-03-15 10:00:00') # first
    @post[4] = create(:post, title: "2014-03-14 10:00:00", group: @open_group, creator: @author, created_at: '2014-03-14 10:00:00') # forth
    @post[5] = create(:post, title: "2014-03-13 10:00:00", group: @open_group, creator: @author, created_at: '2014-03-13 10:00:00') # fifth
  end


  it "GET /posts/group/:group_id; group posts for open group excerpt should be first 200 chars of body when excerpt is blank" do
    post = create(:post, body: Faker::Lorem.characters(300), group: @open_group, creator: @author)

    get_auth "/posts/group/#{@open_group.id}"

    response.status.should eql(200)
    json["posts"].first["generated_excerpt"].should eq post.generated_excerpt
    json["posts"].first["excerpt"].should eq nil
  end

  it "GET /posts/group/:group_id; group posts for open group excerpt should be first 200 chars of body when excerpt is blank" do
    post = create(:post, excerpt: 'my own excerpt', body: Faker::Lorem.characters(300), group: @open_group, creator: @author)

    get_auth "/posts/group/#{@open_group.id}"

    response.status.should eql(200)
    json["posts"].first["excerpt"].should eq post.excerpt
  end

  # Sorting tests.  Sort order is latest posts.created_at, post_likes.created_at, or post_comments.created_at descending, post_attachments.created_at
  # =================================================================================================================================================
  it "GET /posts/group/:group_id; group posts for open group, posts have no activity (i.e, likes or comments), should sort by post.create_at" do
    create_post_for_sort_test

    get_auth "/posts/group/#{@open_group.id}"

    response.status.should eql(200)
    json["posts"].first["title"].should eq @post[3].title
    json["posts"].second["title"].should eq @post[2].title
    json["posts"].third["title"].should eq @post[1].title
    json["posts"].fourth["title"].should eq @post[4].title
    json["posts"].fifth["title"].should eq @post[5].title
  end

  it "GET /posts/group/:group_id; group posts for open group, posts have activity should sort by latest activity" do
    create_post_for_sort_test
    post_liker = create(:user, :random)
    post_commenter1 = create(:user, :random)
    post_commenter2 = create(:user, :random)
    create(:post_like, post: @post[5], user: post_liker, created_at: '2014-03-15 20:00:00') # newest like
    create(:post_like, post: @post[5], user: create(:user, :random), created_at: '2014-03-15 18:30:00')
    create(:post_comment, body: 'Nice post!', post: @post[1], user: post_commenter1, created_at: '2014-03-15 18:00:00')
    create(:post_comment, body: 'Nice post!', post: @post[4], user: post_commenter2, created_at: '2014-03-15 12:00:00')

    get_auth "/posts/group/#{@open_group.id}"
    response.status.should eql(200)
    json["posts"].first["title"].should eq @post[5].title
    json["posts"].first["excerpt"].should eq nil
    json["posts"].first["generated_excerpt"].should eq @post[5].body
    json["posts"].first["recent_activity"].to_s.should include "#{post_liker.full_name} liked this post"
    json["posts"].second["title"].should eq @post[1].title
    json["posts"].second["recent_activity"].to_s.should include "#{post_commenter1.full_name} commented on this post"
    json["posts"].third["title"].should eq @post[4].title
    json["posts"].third["recent_activity"].to_s.should include "#{post_commenter2.full_name} commented on this post"
    json["posts"].fourth["title"].should eq @post[3].title
    json["posts"].fifth["title"].should eq @post[2].title
  end

  it "GET /posts/group/:group_id; group posts for open group, posts have activity should sort by latest activity, latest activity should be returned in 'recent_activity'" do
    create_post_for_sort_test
    post_liker1 = create(:user, :random)
    post_liker2 = create(:user, :random)
    post_commenter1 = create(:user, :random)
    post_commenter2 = create(:user, :random)
    create(:post_like, post: @post[5], user: post_liker1, created_at: '2014-03-15 20:00:00') # first post
    create(:post_like, post: @post[5], user: create(:user, :random), created_at: '2014-03-15 18:30:00') # first post
    create(:post_like, post: @post[5], user: post_liker2, created_at: '2014-03-15 22:30:00') # first post; latest activity
    create(:post_comment, body: 'Nice post!', post: @post[1], user: post_commenter1, created_at: '2014-03-15 18:00:00')
    create(:post_like, post: @post[1], user: post_liker1, created_at: '2014-03-15 18:05:00') # latest activity for this post
    create(:post_comment, body: 'Nice post!', post: @post[4], user: post_commenter2, created_at: '2014-03-15 12:00:00')

    get_auth "/posts/group/#{@open_group.id}"
    response.status.should eql(200)
    json["posts"].first["title"].should eq @post[5].title
    json["posts"].first["recent_activity"].to_s.should include "#{post_liker2.full_name} liked this post"
    json["posts"].second["title"].should eq @post[1].title
    json["posts"].second["recent_activity"].to_s.should include "#{post_liker1.full_name} liked this post"
    json["posts"].third["title"].should eq @post[4].title
    json["posts"].third["recent_activity"].to_s.should include "#{post_commenter2.full_name} commented on this post"
    json["posts"].fourth["title"].should eq @post[3].title
    json["posts"].fifth["title"].should eq @post[2].title
  end

  it "GET /posts/group/:group_id; group posts for open group, posts have activity should sort by latest activity, latest activity should be returned in 'recent_activity'" do
    create_post_for_sort_test
    post_liker1 = create(:user, :random)
    post_liker2 = create(:user, :random)
    post_commenter1 = create(:user, :random)
    post_commenter2 = create(:user, :random)
    create(:post_attachment, post: @post[5], url: 'www.attachment.com/foo.jpg', created_at: '2014-03-15 22:45:00') # first post; latest activity
    create(:post_like, post: @post[5], user: post_liker1, created_at: '2014-03-15 20:00:00') # first post
    create(:post_like, post: @post[5], user: create(:user, :random), created_at: '2014-03-15 18:30:00') # first post
    create(:post_like, post: @post[5], user: post_liker2, created_at: '2014-03-15 22:30:00') # first post
    create(:post_comment, body: 'Nice post!', post: @post[1], user: post_commenter1, created_at: '2014-03-15 18:00:00')
    create(:post_like, post: @post[1], user: post_liker1, created_at: '2014-03-15 18:05:00') # latest activity for this post
    create(:post_comment, body: 'Nice post!', post: @post[4], user: post_commenter2, created_at: '2014-03-15 12:00:00')

    get_auth "/posts/group/#{@open_group.id}"
    
    response.status.should eql(200)
    json["posts"].first["title"].should eq @post[5].title
    json["posts"].first["recent_activity"].to_s.should include "#{@post[5].creator.full_name} added attachment"
    json["posts"].second["title"].should eq @post[1].title
    json["posts"].second["recent_activity"].to_s.should include "#{post_liker1.full_name} liked this post"
    json["posts"].third["title"].should eq @post[4].title
    json["posts"].third["recent_activity"].to_s.should include "#{post_commenter2.full_name} commented on this post"
    json["posts"].fourth["title"].should eq @post[3].title
    json["posts"].fifth["title"].should eq @post[2].title
  end

  it "GET /posts/group/:group_id; group posts for open group, requesting user is not a member, still gets posts" do
    5.times do |x|
      create(:post, body: "Post #{x}", group: @open_group)
    end

    get_auth "/posts/group/#{@open_group.id}"
    response.status.should eql(200)
    json["posts"].count.should eq(5)
  end

  it "GET /posts/group/:group_id; group posts for private group, requesting user is a member, get's posts" do
    group = create(:group, :private)
    create(:group_member, user: @user, group: group)
    create(:post, body: "Post body", group: group)

    get_auth "/posts/group/#{group.id}"
    response.status.should eql(200)
  end

  it "GET /posts/group/:group_id; group posts for secret group, requesting user is a member, get's posts" do
    group = create(:group, :secret)
    create(:group_member, user: @user, group: group)
    create(:post, body: "Post body", group: group)

    get_auth "/posts/group/#{group.id}"
    response.status.should eql(200)
  end

  it "GET /posts/group/:group_id; group posts for private group, requesting user is not a member, get's 403" do
    group = create(:group, :private)
    create(:post, body: "Post body", group: group)

    get_auth "/posts/group/#{group.id}"
    response.status.should eql(403)
  end

  it "GET /posts/group/:group_id; group posts for secret group, requesting user is not a member, get's 403" do
    group = create(:group, :secret)
    create(:post, body: "Post body", group: group)

    get_auth "/posts/group/#{group.id}"
    response.status.should eql(404)
  end

  it "GET /posts/group/:group_id; get a 404 status when using invalid group id" do
    get_auth "/posts/group/0"
    response.status.should eql(404)
  end

end
