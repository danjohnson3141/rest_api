require 'spec_helper'

describe 'UserConnections' do

  before(:all) do
    @sender = create(:user, :random)
    @recipient = create(:user, :random)
  end

  it "initiating a connection notifies recipient" do
    user_connection = UserConnection.create(sender_user: @sender, recipient_user: @recipient)
    Notification.where(user: user_connection.recipient_user, user_connection: user_connection).first.body.should eq "#{user_connection.sender_user.full_name} wants to connect with you."
  end
  
  it "initiating a connection doesn't notify recipient because notifications are turned off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    user_connection = UserConnection.create(sender_user: @sender, recipient_user: @recipient)
    Notification.where(user: user_connection.recipient_user, user_connection: user_connection).first.present?.should eq false
  end

  it "initiating a connection doesn't notify recipient because notifications are turned off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @recipient.user_role)
    user_connection = UserConnection.create(sender_user: @sender, recipient_user: @recipient)
    Notification.where(user: user_connection.recipient_user, user_connection: user_connection).first.present?.should eq false
  end

  it "approving a connection notifies sender" do
    user_connection = UserConnection.create(sender_user: @sender, recipient_user: @recipient)
    user_connection.approve
    Notification.where(user: user_connection.sender_user, user_connection: user_connection).first.body.should eq "#{user_connection.recipient_user.full_name} has accepted your connection."
  end
  
  it "approving a connection doesn't notify sender because notifications are turned off (App level)" do
    create(:app_setting, app_setting_option_id: 57)
    user_connection = UserConnection.create(sender_user: @sender, recipient_user: @recipient)
    user_connection.approve
    Notification.where(user: user_connection.sender_user, user_connection: user_connection).first.present?.should eq false
  end

  it "approving a connection doesn't notify sender because notifications are turned off (UserRole level)" do
    create(:app_setting, app_setting_option_id: 58, user_role: @sender.user_role)
    user_connection = UserConnection.create(sender_user: @sender, recipient_user: @recipient)
    user_connection.approve
    Notification.where(user: user_connection.sender_user, user_connection: user_connection).first.present?.should eq false
  end

end
