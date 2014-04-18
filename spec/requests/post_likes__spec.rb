require 'spec_helper'

describe PostLike do

  before(:all) do
    @user = create(:user)
    @author = create(:user, :random, title: "Author")
    @post = create(:post, :random, :event, creator: @user, updator: @user)
  end

  it "GET /post_likes/:id; get 1 post like record" do
    post_like = create(:post_like, :random, user: @author, creator: @author, updator: @author)

    get_auth "/post_likes/#{post_like.id}"

    response.status.should eq 200
    json.count.should eq(1)
    json["post_like"]["id"].should eq post_like.id
    json["post_like"]["user"]["id"].should eq post_like.user.id
    json["post_like"]["post"]["id"].should eq post_like.post.id
  end

  it "POST /post_likes; try to create a new post like, fails because likes are turned off at App level" do
    create(:app_setting, app_setting_option_id: 109)

    post_auth '/post_likes', { post_like: { post_id: @post.id } }
    response.status.should eq 403
  end

  it "POST /post_likes; creates a new post like" do
    create(:event_user, user: @user, event: @post.event)

    post_auth '/post_likes', { post_like: { post_id: @post.id } }
    response.status.should eq 201
    json["post_like"]["user"]["id"].should eq @user.id
    json["post_like"]["post"]["id"].should eq @post.id
  end

  it "DELETE /post_likes/:id; deletes your post like" do
    post_like = create(:post_like, :random, post: @post, user: @user, creator: @user, updator: @user)

    delete_auth "/post_likes/#{post_like.id}"
    response.status.should eq 204
  end

  it "DELETE /post_likes/:id; attempts to delete someone else's post like, invalid action" do
    post_like = create(:post_like, :random, post: @post, user: @author, creator: @author, updator: @author)

    delete_auth "/post_likes/#{post_like.id}"
    response.status.should eq 403
  end

end
