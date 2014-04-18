require 'spec_helper'

describe 'PostContributors' do  

  before(:all) do
    @user = create(:user)
    @group = create(:group, :random)
    create(:group_member, user: @user, group: @group)
  end

  it "GET /posts/group/:group_id; post with multiple authors" do
    post = create(:post, body: 'foo', group: @group)
    user1 = create(:user, :random, creator: @user)
    post_contributor1 = create(:post_contributor, post: post, user: @user)
    post_contributor2 = create(:post_contributor, post: post, user: user1)

    get_auth "/posts/group/#{@group.id}"

    response.status.should eql(200)
    json["posts"].first['authors'].to_s.should include(post.authors.first.first_name)
    json["posts"].first['authors'].to_s.should include(post.authors.second.first_name)
  end

  it "GET /posts/group/:post_id; post with single author" do
    post = create(:post, body: 'foo', group: @group, creator: @user)

    get_auth "/posts/group/#{@group.id}"
    response.status.should eql(200)
    json["posts"].first['authors'].to_s.should include(@user.first_name)
  end

end