require 'spec_helper'

describe 'PostLikes' do

  before(:all) do
    @user = create(:user, :random)
    @post = create(:post, :random, :event, creator: create(:user, :random))
  end

  it "liking a post notifies author and post followers" do
    post_like = PostLike.create(user: @user, post: @post)
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_like.user.full_name} liked your post.", user: @user).first.present?.should eq true
  end

  it "liking a post doesn't notifies author and post followers because notifications are turned off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    post_like = PostLike.create(user: @user, post: @post)
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_like.user.full_name} liked your post.", user: @user).first.present?.should eq false
  end

  it "liking a post doesn't notifies author and post followers because notifications are turned off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @user.user_role)
    post_like = PostLike.create(user: @user, post: @post)
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_like.user.full_name} liked your post.", user: @user).first.present?.should eq false
  end

  it "if post author likes thier post they are not notified" do
    post_like = PostLike.create(user: @post.creator, post: @post)
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_like.user.full_name} liked your post.", user: @user).first.present?.should eq false
  end
end
