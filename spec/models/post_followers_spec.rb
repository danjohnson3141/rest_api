require 'spec_helper'

describe 'PostFollowers' do

  # before(:all) do
  #   @user = create(:user, :random)
  #   @post = create(:post, :random, :event, creator: create(:user, :random))
  # end

  # it "following a post notifies the author" do
  #   post_follower1 = create(:post_follower, user: create(:user, :random), post: @post)
  #   post_follower2 = create(:post_follower, user: create(:user, :random), post: @post)
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower1.user.full_name} is following your post.").first.present?.should eq true
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower2.user.full_name} is following your post.").first.present?.should eq true
  # end

  # it "if author follows thier own post they are not notified" do
  #   post_follower1 = create(:post_follower, user: @post.creator, post: @post)
  #   post_follower2 = create(:post_follower, user: create(:user, :random), post: @post)
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower1.user.full_name} is following your post.").first.present?.should eq false
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower2.user.full_name} is following your post.").first.present?.should eq true
  # end

  # it "following a post doesn't notifies the author because notifications are off (App level)" do
  #   create(:app_setting, app_setting_option_id: 57)
  #   post_follower1 = create(:post_follower, user: create(:user, :random), post: @post)
  #   post_follower2 = create(:post_follower, user: create(:user, :random), post: @post)
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower1.user.full_name} is following your post.").first.present?.should eq false
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower2.user.full_name} is following your post.").first.present?.should eq false
  # end

  # it "following a post doesn't notifies the author because notifications are off (UserRole level)" do
  #   create(:app_setting, app_setting_option_id: 58, user_role: @post.creator.user_role)
  #   post_follower1 = create(:post_follower, user: create(:user, :random), post: @post)
  #   post_follower2 = create(:post_follower, user: create(:user, :random), post: @post)
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower1.user.full_name} is following your post.").first.present?.should eq false
  #   Notification.where(notification_user: @post.creator, post: @post, body: "#{post_follower2.user.full_name} is following your post.").first.present?.should eq false
  # end

end
