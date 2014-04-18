require 'spec_helper'

describe 'Users' do
  
  before(:all) do
    user_role_notification_on = create(:user_role, name: 'notification on')
    user_role_notification_off = create(:user_role, name: 'notification off')
    @user = create(:user, :random)
    @user_connection1 = create(:user_connection, :approved, sender_user: @user, recipient_user: create(:user, :random, user_role: user_role_notification_on))
    @user_connection2 = create(:user_connection, :approved, sender_user: create(:user, :random, user_role: user_role_notification_off), recipient_user: @user)
  end

  # Notificaitons
  it "updating user's title/organization notifies the user's connections, when settings permit." do
    @user.update_attributes(title: 'Reset', organization_name: 'Reset') # It is necessary to reset the title/organization each time to ensure a change condition
    @user.update(title: 'New Title', organization_name: 'New Organization')
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} title has changed to \"#{@user.title}\".", user: @user).present?.should eq true
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} title has changed to \"#{@user.title}\".", user: @user).present?.should eq true
  end

  it "updating user's title/organization doesn't notifies the group owner when their notifications app setting is off (App level)" do
    @user.update_attributes(title: 'Reset', organization_name: 'Reset') # It is necessary to reset the title/organization each time to ensure a change condition
    create(:app_setting, app_setting_option_id: 57)
    @user.update(title: 'New Title', organization_name: 'New Organization')
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} title has changed to \"#{@user.title}\".", user: @user).present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} title has changed to \"#{@user.title}\".", user: @user).present?.should eq false
  end

  it "updating user's title/organization doesn't notifies the group owner when their notifications app setting is off (UserRole level)" do
    @user.update_attributes(title: 'Reset', organization_name: 'Reset') # It is necessary to reset the title/organization each time to ensure a change condition
    create(:app_setting, app_setting_option_id: 58, user_role: @user_connection1.recipient_user.user_role)
    @user.update(title: 'New Title', organization_name: 'New Organization')
    Notification.where(notification_user: @user_connection1.recipient_user, body: "#{@user.full_name} title has changed to \"#{@user.title}\".", user: @user).present?.should eq false
    Notification.where(notification_user: @user_connection2.sender_user, body: "#{@user.full_name} title has changed to \"#{@user.title}\".", user: @user).present?.should eq true
  end

  it "Email address should be unique" do
    user1 = User.create(email: "test@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    user2 = User.create(email: "test@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    
    user2.errors.messages[:email].should eq ["has already been taken"]
  end

  it "Alternate Email address should be unique" do
    user1 = User.create(email: "test1@example.com", alt_email: "alt@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    user2 = User.create(email: "test2@example.com", alt_email: "alt@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    
    user2.errors.messages[:alt_email].should eq ["has already been taken"]
  end

  it "Alternate Email address should not be another users primary email address" do
    user1 = User.create(email: "test1@example.com", alt_email: "alt@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    user2 = User.create(email: "test2@example.com", alt_email: "test1@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    
    user2.errors.messages[:alt_email].should eq ["has already been taken"]
  end

  it "Email address should not be another users alternate email address" do
    user1 = User.create(email: "test1@example.com", alt_email: "alt@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    user2 = User.create(email: "alt@example.com", alt_email: "test2@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    
    user2.errors.messages[:email].should eq ["has already been taken"]
  end  

  it "Update to email address should not be another users alternate email address" do
    user1 = User.create(email: "unique1@example.com", alt_email: "unique2@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    user2 = User.create(email: "unique3@example.com", alt_email: "unique4@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    
    user2.alt_email = user1.email
    user2.save
    user2.errors.messages[:alt_email].should eq ["has already been taken"]
    check_user_email = User.find(user2.id)
    check_user_email.alt_email.should_not eq user1.email
  end  

  it "Update to mail address should not be another users alternate email address" do
    user1 = User.create(email: "unique1@example.com", alt_email: "unique2@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    user2 = User.create(email: "unique3@example.com", alt_email: "unique4@example.com", first_name: "test", last_name: "user", password: "abcdef1234")
    
    user2.email = user1.alt_email
    user2.save
    user2.errors.messages[:email].should eq ["has already been taken"]
    check_user_email = User.find(user2.id)
    check_user_email.alt_email.should_not eq user1.alt_email
  end

end