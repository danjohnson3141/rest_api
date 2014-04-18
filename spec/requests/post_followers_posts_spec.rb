require 'spec_helper'

describe 'PostFollowersPosts' do  
  before(:all) do
    @user = create(:user)
  end

  it "GET /post_followers/posts/:user_id; get 2 post_followers records (2 posts)" do
    post1 = create(:post, :random, :event, creator: create(:user, :random))
    post2 = create(:post, :random, :event, creator: create(:user, :random))
    post_follower1 = create(:post_follower, user: @user, post: post1)
    post_follower2 = create(:post_follower, user: @user, post: post2)
    
    get_auth "/post_followers/posts/#{@user.id}"
    response.status.should eql(200)
    json["post_followers"].count.should eq(2)
    json["post_followers"].first["id"].should eq post_follower1.id
    json["post_followers"].first["post"]["id"].should eq post1.id
    json["post_followers"].second["id"].should eq post_follower2.id
    json["post_followers"].second["post"]["id"].should eq post2.id
  end

  it "GET /post_followers/posts/:user_id; get 0 post_followers records for a user" do
    get_auth "/post_followers/posts/#{@user.id}"
    response.status.should eql(200)
    json["post_followers"].count.should eq(0)
  end

  it "GET /post_followers/posts/:user_id; requests a user ID that is invalid" do
    get_auth "/post_followers/posts/0"
    response.status.should eql(404)  
  end

end