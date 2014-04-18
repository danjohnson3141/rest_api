require 'spec_helper'

describe "Notifications" do

  before(:all) do
    @user = create(:user)
    @user2 = create(:user, :random)
    @group = create(:group, :private)
    @post = create(:post, :event, :random)
  end

  it "GET /notifications/:id; get all notifications for user" do
    group_notification = create(:notification, body: "Group notification body", notification_user: @user, group: @group, created_at: Time.now - 20.minutes)
    post_notification = create(:notification, body: "post notification body", notification_user: @user, post: @post, created_at: Time.now - 30.minutes)

    get_auth "/notifications/user/#{@user.id}"
    response.status.should eq 200
    json["notifications"].count.should eq(2)
    json["notifications"][0]["id"].should eq group_notification.id
    json["notifications"][0]["body"].should eq group_notification.body
    json["notifications"][0]["ago"].should eq "20m"
    json["notifications"][0]["group_id"].should eq group_notification.group.id
    json["notifications"][1]["id"].should eq post_notification.id
    json["notifications"][1]["body"].should eq post_notification.body
    json["notifications"][1]["ago"].should eq "30m"
    json["notifications"][1]["post_id"].should eq post_notification.post.id
  end  

  it "GET /notifications/:id; attempts to return notifications for another user, should 403" do
    group_notification = create(:notification, body: "Group notification body", notification_user: @user2, group: @group, created_at: Time.now - 20.minutes)
    post_notification = create(:notification, body: "post notification body", notification_user: @user2, post: @post, created_at: Time.now - 30.minutes)

    get_auth "/notifications/user/#{@user2.id}"
    
    response.status.should eq 403
  end

end
