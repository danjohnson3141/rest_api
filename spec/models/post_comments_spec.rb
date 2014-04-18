require 'spec_helper'

describe 'PostComments' do

  before(:all) do
    @user = create(:user, :random)
    @post = create(:post, :random, :event, creator: create(:user, :random))
    @post_follower1 = create(:post_follower, user: create(:user, :random), post: @post)
    @post_follower2 = create(:post_follower, user: create(:user, :random, :sponsor), post: @post)
  end

  it "commenting on a post notifies author and post followers" do
    post_comment = PostComment.create(user: @user, post: @post, body: 'Cool post dude')
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_comment.user.full_name} commented on your post.", user: @user).first.present?.should eq true
    Notification.where(notification_user: @post_follower1.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: @user).first.present?.should eq true
    Notification.where(notification_user: @post_follower2.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: @user).first.present?.should eq true
  end

  it "commenting on a post doesn't notifies author and post followers because notifications are turned off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    post_comment = PostComment.create(user: @user, post: @post, body: 'Cool post dude')
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_comment.user.full_name} commented on your post.", user: @user).first.present?.should eq false
    Notification.where(notification_user: @post_follower1.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: @user).first.present?.should eq false
    Notification.where(notification_user: @post_follower2.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: @user).first.present?.should eq false
  end

  it "commenting on a post doesn't notifies author and post followers because notifications are turned off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @user.user_role)
    post_comment = PostComment.create(user: @user, post: @post, body: 'Cool post dude')
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_comment.user.full_name} commented on your post.", user: @user).first.present?.should eq false
    Notification.where(notification_user: @post_follower1.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: @user).first.present?.should eq false
    Notification.where(notification_user: @post_follower2.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: @user).first.present?.should eq true
  end

  it "if post author comments on thier post they are not notified" do
    post_comment = PostComment.create(user: @post.creator, post: @post, body: 'I really like my post')
    Notification.where(notification_user: @post.creator, post: @post, body: "#{post_comment.user.full_name} commented on your post.", user: post_comment.user).first.present?.should eq false
    Notification.where(notification_user: @post_follower1.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: post_comment.user).first.present?.should eq true
    Notification.where(notification_user: @post_follower2.user, post: @post, body: "#{post_comment.user.full_name} commented on a post you're following.", user: post_comment.user).first.present?.should eq true
  end
end
