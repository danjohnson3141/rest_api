require 'spec_helper'

describe 'PostFollowers' do
  
  before(:all) do
    @user = create(:user)
    @creator = create(:user, :random)
    @post = create(:post, :random, :event, creator: @user, updator: @user)
  end

  it "POST /post_followers; create new post follower" do
    post_auth '/post_followers', { post_follower: { post_id: @post.id } }
    
    response.status.should eql(201)
    json["post_follower"]["user"]["id"].should eq @user.id
    json["post_follower"]["post"]["id"].should eq @post.id
  end  

  it "POST /post_followers; attempts to make another follow a post, still uses current user" do
    user1 = create(:user, :random)

    post_auth '/post_followers', { post_follower: { user_id: user1.id, post_id: @post.id } }
    response.status.should eql(201)
    json["post_follower"]["user"]["id"].should eq @user.id
    json["post_follower"]["post"]["id"].should eq @post.id
  end

  it "POST /post_followers; create new post follower, will fail because post is already being followed" do
    create(:post_follower, user: @user, post: @post)

    post_auth '/post_followers', { post_follower: { post_id: @post.id } }
    response.status.should eql(422)
  end

  it "DELETE /post_followers/:id; delete an existing post follower" do
    post_follower = create(:post_follower, user: @user, post: @post, creator: @user)

    delete_auth "/post_followers/#{post_follower.id}"
    response.status.should eql(204)
  end  

  it "DELETE /post_followers/:id; attempts to delete a follower record for another user" do
    user1 = create(:user, :random)
    post_follower = create(:post_follower, user: user1, post: @post)

    delete_auth "/post_followers/#{post_follower.id}"
    response.status.should eql(403)
  end

  it "DELETE /post_followers/:id; delete a follower that does not exist" do
    delete_auth "/post_followers/0"
    response.status.should eql(404)
  end

end