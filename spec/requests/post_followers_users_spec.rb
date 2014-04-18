require 'spec_helper'

describe 'PostFollowersUsers' do
  before(:all) do
    @user = create(:user)
    @post = create(:post, :random, :event, creator: create(:user, :random))
  end

  it "GET /post_followers/users/:post_id; get 2 post_followers records ( 2 users )" do
    post_follower1 = create(:post_follower, user: create(:user, :random), post: @post)
    post_follower2 = create(:post_follower, user: create(:user, :random), post: @post)

    get_auth "/post_followers/users/#{@post.id}"
    response.status.should eql(200)
    json["post_followers"].count.should eq(2)
    json["post_followers"].first["id"].should eq post_follower1.id
    json["post_followers"].second["id"].should eq post_follower2.id
  end

  it "GET /post_followers/users/:post_id; get 0 post_followers records for an post" do
    get_auth "/post_followers/users/#{@post.id}"
    response.status.should eql(200)
    json["post_followers"].count.should eq(0)
  end

  it "GET /post_followers/users/:post_id; get 404 for a post that does not exist" do
    get_auth "/post_followers/users/0"
    response.status.should eql(404)
  end

end
