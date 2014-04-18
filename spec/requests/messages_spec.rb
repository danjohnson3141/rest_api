require 'spec_helper'

describe 'Messages' do

  before(:all) do
    @user = create(:user)
    @user1 = create(:user, :random)
    @user2 = create(:user, :random)
    @user3 = create(:user, :random)
    @user4 = create(:user, :random)
  end

  it "Evanta format for time ago" do
    message = create(:message, :random, created_at: Time.now, sender_user: @user1, recipient_user: @user)
    
    message.created_at = Time.now - 1.minutes
    message.ago.should eq "1m"

    message.created_at = Time.now - 59.minutes
    message.ago.should eq "59m"

    message.created_at = Time.now - 60.minutes
    message.ago.should eq "1h"

    message.created_at = Time.now - 1409.minutes
    message.ago.should eq "23h"

    message.created_at = Time.now - 1410.minutes
    message.ago.should eq "24h"

    message.created_at = Time.now - 1440.minutes
    message.ago.should eq "1d"

    message.created_at = Time.now - 99.days
    message.ago.should eq "99d"

    message.created_at = Time.now - 6299.days
    message.ago.should eq "6299d"

    message.ago("does_not_exist").should eq nil
  end

  it "GET /messages; list the most recent message for each user you have had a converstion with" do
    message1 = create(:message, :random, sender_user: @user1, recipient_user: @user,  created_at: Time.now - 1.day)     
    message2 = create(:message, :random, sender_user: @user2, recipient_user: @user,  created_at: Time.now - 3.days)
    message3 = create(:message, :random, sender_user: @user3, recipient_user: @user,  created_at: Time.now - 1.hour, viewed_date: Time.now - 5.minutes)
    message4 = create(:message, :random, sender_user: @user4, recipient_user: @user,  created_at: Time.now - 4.hours)    
    message5 = create(:message, :random, sender_user: @user4, recipient_user: @user,  created_at: Time.now - 5.minutes, viewed_date: Time.now - 2.minutes)
    message6 = create(:message, :random, sender_user: @user,  recipient_user: @user4, created_at: Time.now - 6.days, viewed_date: Time.now - 3.days)
    message7 = create(:message, :random, sender_user: @user1, recipient_user: @user,  created_at: Time.now - 10.hours)  
    message8 = create(:message, :random, sender_user: @user,  recipient_user: @user4, created_at: Time.now - 8.hours)    

    get_auth "/messages"
    
    response.status.should eql(200)
    json["messages"].count eq(5)

    json["messages"][0]["id"].should eq message5.id
    json["messages"][0]["unread"].should eq false
    json["messages"][0]["sender_user_id"].should eq @user4.id
    json["messages"][0]["recipient_user_id"].should eq @user.id
    json["messages"][0]["ago"].should eq "5m"
    json["messages"][0]["user"]["id"].should eq @user4.id

    json["messages"][1]["id"].should eq message3.id
    json["messages"][1]["unread"].should eq false
    json["messages"][1]["sender_user_id"].should eq @user3.id
    json["messages"][1]["recipient_user_id"].should eq @user.id
    json["messages"][1]["ago"].should eq "1h"
    json["messages"][1]["user"]["id"].should eq @user3.id

    json["messages"][2]["id"].should eq message7.id
    json["messages"][2]["unread"].should eq true
    json["messages"][2]["sender_user_id"].should eq @user1.id
    json["messages"][2]["recipient_user_id"].should eq @user.id
    json["messages"][2]["ago"].should eq "10h"
    json["messages"][2]["user"]["id"].should eq @user1.id

    json["messages"][3]["id"].should eq message2.id
    json["messages"][3]["unread"].should eq true
    json["messages"][3]["sender_user_id"].should eq @user2.id
    json["messages"][3]["recipient_user_id"].should eq @user.id
    json["messages"][3]["ago"].should eq "3d"
    json["messages"][3]["user"]["id"].should eq @user2.id
  end

  it "DELETE /messages/conversation/:user_id; removes an entire conversation you had with another user" do
    message1 = create(:message, :random, created_at: Time.now - 1.day, sender_user: @user1, recipient_user: @user)
    message2 = create(:message, :random, created_at: Time.now - 3.days, sender_user: @user2, recipient_user: @user, viewed_date: Time.now - 2.days)
    message3 = create(:message, :random, created_at: Time.now - 1.hour, sender_user: @user3, recipient_user: @user, viewed_date: Time.now - 5.minutes)
    message4 = create(:message, :random, created_at: Time.now - 4.hours, sender_user: @user4, recipient_user: @user)
    message5 = create(:message, :random, created_at: Time.now - 5.minutes, sender_user: @user4, recipient_user: @user, viewed_date: Time.now - 2.minutes)
    message6 = create(:message, :random, created_at: Time.now - 6.days, sender_user: @user, recipient_user: @user4, viewed_date: Time.now - 3.days)
    message7 = create(:message, :random, created_at: Time.now - 10.hours, sender_user: @user1, recipient_user: @user)
    message8 = create(:message, :random, created_at: Time.now - 8.hours, sender_user: @user, recipient_user: @user4)

    Message.get_message_list(@user).count.should eq 4
    Message.get_message_list(@user4).count.should eq 1
    Message.get_conversation(@user, @user4).count.should eq 4

    delete_auth "/messages/conversation/#{@user4.id}"
    
    response.status.should eql(204)
    Message.get_message_list(@user).count.should eq 3
    Message.get_message_list(@user4).count.should eq 1
    Message.get_conversation(@user, @user4).count.should eq 0
  end


  it "GET /messages/conversation/:user_id; list messages you have had with another user" do
    message1 = create(:message, :random, sender_user: @user1, recipient_user: @user,  created_at: Time.now - 1.day)
    message2 = create(:message, :random, sender_user: @user1, recipient_user: @user,  created_at: Time.now - 4.hours)
    message3 = create(:message, :random, sender_user: @user1, recipient_user: @user,  created_at: Time.now - 5.minutes, viewed_date: Time.now - 2.minutes)
    message4 = create(:message, :random, sender_user: @user,  recipient_user: @user1, created_at: Time.now - 6.days, viewed_date: Time.now - 3.days)
    message5 = create(:message, :random, sender_user: @user1, recipient_user: @user,  created_at: Time.now - 1.day)
    message6 = create(:message, :random, sender_user: @user,  recipient_user: @user1, created_at: Time.now - 8.hours)

    get_auth "/messages/conversation/#{@user1.id}"
    
    response.status.should eql(200)
    json["messages"].count eq(6)
    json["messages"][0]["id"].should eq message3.id
    json["messages"][0]["unread"].should eq false
    json["messages"][0]["viewed_date"].should be
    json["messages"][0]["sender_user_id"].should eq @user1.id
    json["messages"][0]["recipient_user_id"].should eq @user.id
    json["messages"][0]["ago"].should eq "5m"

    json["messages"][1]["id"].should eq message2.id
    json["messages"][1]["unread"].should eq false
    json["messages"][1]["viewed_date"].should be
    json["messages"][1]["sender_user_id"].should eq @user1.id
    json["messages"][1]["recipient_user_id"].should eq @user.id
    json["messages"][1]["ago"].should eq "4h"

    json["messages"][2]["id"].should eq message6.id
    json["messages"][2]["unread"].should eq false
    json["messages"][2]["viewed_date"].should_not be
    json["messages"][2]["sender_user_id"].should eq @user.id
    json["messages"][2]["recipient_user_id"].should eq @user1.id
    json["messages"][2]["ago"].should eq "8h"

    json["messages"][3]["id"].should eq message1.id
    json["messages"][3]["unread"].should eq false
    json["messages"][3]["viewed_date"].should be
    json["messages"][3]["sender_user_id"].should eq @user1.id
    json["messages"][3]["recipient_user_id"].should eq @user.id
    json["messages"][3]["ago"].should eq "1d"

    json["messages"][4]["id"].should eq message5.id
    json["messages"][4]["unread"].should eq false
    json["messages"][4]["viewed_date"].should be
    json["messages"][4]["sender_user_id"].should eq @user1.id
    json["messages"][4]["recipient_user_id"].should eq @user.id
    json["messages"][4]["ago"].should eq "1d"

    json["messages"][5]["id"].should eq message4.id
    json["messages"][5]["unread"].should eq false
    json["messages"][5]["viewed_date"].should be
    json["messages"][5]["sender_user_id"].should eq @user.id
    json["messages"][5]["recipient_user_id"].should eq @user1.id
    json["messages"][5]["ago"].should eq "6d"

    Message.find(message1.id).viewed_date.should be
    Message.find(message2.id).viewed_date.should be
    Message.find(message3.id).viewed_date.should be
    Message.find(message4.id).viewed_date.should be
    Message.find(message5.id).viewed_date.should be
    Message.find(message6.id).viewed_date.should_not be
  end

  it "GET /messages/conversation/:id; message should get viewed date updated on first viewing" do
    message = create(:message, :random, sender_user: @user1, recipient_user: @user )
    Message.find(message.id).viewed_date.should eq nil
    
    get_auth "/messages/conversation/#{@user1.id}"
    response.status.should eql(200)
    Message.find(message.id).viewed_date.should_not eq nil
  end   

  it "GET /messages/conversation/:id; already read message should not get viewed date updated" do
    read_time = Time.now - 8.hours
    read_time_check = read_time.to_s
    message = create(:message, :random, sender_user: @user1, recipient_user: @user, viewed_date: read_time )
    
    get_auth "/messages/conversation/#{@user1.id}"
    response.status.should eql(200)
    json["messages"].first["viewed_date"].to_time.to_s.should eq read_time_check
  end  

  it "GET /messages/conversation/:id; messages from user shouldn't get marked with viewed date when viewed by user" do
    message1 = create(:message, :random, sender_user: @user, recipient_user: @user1 )
    message2 = create(:message, :random, sender_user: @user1, recipient_user: @user )
    message3 = create(:message, :random, sender_user: @user, recipient_user: @user1 )
    Message.find(message1.id).viewed_date.should eq nil
    Message.find(message2.id).viewed_date.should eq nil
    Message.find(message3.id).viewed_date.should eq nil
    
    get_auth "/messages/conversation/#{@user1.id}"
    response.status.should eql(200)
    Message.find(message1.id).viewed_date.should eq nil
    Message.find(message2.id).viewed_date.should_not eq nil
    Message.find(message1.id).viewed_date.should eq nil
  end  

  it "GET /messages/conversation/:id; checks that deleted by recipient messages do not appear" do
    message1 = create(:message, body: "recipient deleted", sender_user: @user1, recipient_user: @user, viewed_date: Time.now - 2.days , recipient_deleted: true)
    message2 = create(:message, :random, sender_user: @user1, recipient_user: @user )
    
    get_auth "/messages/conversation/#{@user1.id}"
    
    response.status.should eql(200)
    json["messages"].count.should eq(1)
    json["messages"].first["id"].should eq(message2.id)
  end   

  it "GET /messages/conversation/:id; checks that deleted by sender messages do not appear" do
    message1 = create(:message, body: "sender deleted", sender_user: @user, recipient_user: @user1, viewed_date: Time.now - 2.days , sender_deleted: true)
    message2 = create(:message, :random, sender_user: @user, recipient_user: @user1 )
    
    get_auth "/messages/conversation/#{@user1.id}"
    
    response.status.should eql(200)
    json["messages"].count.should eq(1)
    json["messages"].first["id"].should eq(message2.id)
  end   

  it "GET /messages/conversation/:id; checks that deleted by sender messages appear" do
    message1 = create(:message, :random, body: "sender deleted", sender_user: @user1, recipient_user: @user, viewed_date: Time.now - 2.days, sender_deleted: true ) 
    message2 = create(:message, :random, sender_user: @user1, recipient_user: @user )
    
    get_auth "/messages/conversation/#{@user1.id}"
    
    response.status.should eql(200)
    json["messages"].count.should eq(2)
  end  

  it "POST /messages; Send a message to a user" do
    post_auth "/messages", { message: { recipient_user_id: @user1.id, body: "Test message" } }
    
    response.status.should eql(201)
    json["message"]["unread"].should eq false
    json["message"]["viewed_date"].should eq nil
    json["message"]["body"].should eq "Test message"
    json["message"]["sender_user_id"].should eq @user.id
    json["message"]["recipient_user_id"].should eq @user1.id
    json["message"]["ago"].should eq "0m"
    json["message"]["user"]["id"].should eq @user1.id
  end

  it "POST /messages; Send a message to yourself" do
    post_auth "/messages", { message: { recipient_user_id: @user.id, body: "Test message" } }
    
    response.status.should eql(403)
  end  

  it "POST /messages; Send a message to a user that does not exist" do
    post_auth "/messages", { message: { recipient_user_id: 0, body: "Test message" } }
    
    response.status.should eql(404)
  end  

  it "POST /messages; attempts to send a stupidly long message" do
    post_auth "/messages", { message: { recipient_user_id: @user1.id, body: "#{Faker::Lorem.paragraphs(paragraph_count = 50)}" } }
    
    response.status.should eql(422)
    json["body"].should eq ["is too long (maximum is 6000 characters)"]
  end

  it "POST /messages; attempts to post a message from somebody else, ignores bad data" do
    post_auth "/messages", { message: { recipient_user_id: @user1.id, sender_user_id: @user2.id, body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}" } }
    
    response.status.should eql(201)
    json["message"]["sender_user_id"].should eq @user.id
  end

  it "POST /messages; attempts to post a message without any body text" do
    post_auth "/messages", { message: { recipient_user_id: @user1.id} }
    
    response.status.should eql(422)
    json["body"].should eq ["can't be blank"]
  end

  it "POST /messages; attempts to post a message without a recipient" do
    post_auth "/messages", { message: { body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}"} }
    
    response.status.should eql(422)
  end

  it "POST /messages; attempts to post a message with a viewed date" do
    post_auth "/messages", { message: { body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id, viewed_date: Time.now - 99.days} }
    
    response.status.should eql(201)
    json["message"]["viewed_date"].should eq nil
  end  

  it "POST /messages; attempts to post a message with a viewed date" do
    post_auth "/messages", { message: { body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id, viewed_date: Time.now - 99.days} }
    
    response.status.should eql(201)
    json["message"]["viewed_date"].should eq nil
  end  

  it "POST /messages; attempts to post a message with sender_deleted" do
    post_auth "/messages", { message: { sender_deleted: true, body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id, viewed_date: Time.now - 99.days} }
    
    response.status.should eql(201)
    Message.where("recipient_user_id = #{@user1.id} AND sender_user_id = #{@user.id}").first.sender_deleted.should eq false
  end  

  it "POST /messages; attempts to post a message with recipient_deleted" do
    post_auth "/messages", { message: { recipient_deleted: true, body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id, viewed_date: Time.now - 99.days} }
    
    response.status.should eql(201)
    Message.where("recipient_user_id = #{@user1.id} AND sender_user_id = #{@user.id}").first.recipient_deleted.should eq false
  end  

  it "POST /messages; attempts to post a message with wrong created_by info" do
    post_auth "/messages", { message: { created_by: @user4.id, body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id, viewed_date: Time.now - 99.days} }
    
    response.status.should eql(201)
    Message.where("recipient_user_id = #{@user1.id} AND sender_user_id = #{@user.id}").first.created_by.should_not eq @user4.id
  end

  it "DELETE /message/:id; archives a message to user" do
    message = create(:message, body: "test message", created_at: Time.now - 1.day, sender_user: @user1, recipient_user: @user)

    delete_auth "/messages/#{message.id}"
    
    response.status.should eql(204)
    Message.where("recipient_user_id = #{@user.id} AND sender_user_id = #{@user1.id}").first.recipient_deleted.should eq true
    Message.where("recipient_user_id = #{@user.id} AND sender_user_id = #{@user1.id}").first.sender_deleted.should eq false
  end  

  it "DELETE /message/:id; archives a message from user" do
    message = create(:message, body: "test message", sender_user: @user, recipient_user: @user1)

    delete_auth "/messages/#{message.id}"
    
    response.status.should eql(204)
    Message.where("recipient_user_id = #{@user1.id} AND sender_user_id = #{@user.id}").first.sender_deleted.should eq true
    Message.where("recipient_user_id = #{@user1.id} AND sender_user_id = #{@user.id}").first.recipient_deleted.should eq false
  end

  it "DELETE /message/:id; archives a message that is not yours" do
    message = create(:message, body: "test message", sender_user: @user1, recipient_user: @user2)

    delete_auth "/messages/#{message.id}"
    
    response.status.should eql(403)
    Message.where("recipient_user_id = #{@user2.id} AND sender_user_id = #{@user1.id}").first.sender_deleted.should eq false
    Message.where("recipient_user_id = #{@user2.id} AND sender_user_id = #{@user1.id}").first.recipient_deleted.should eq false
  end


  it "DELETE /message/:id; archives a message that does not exist" do
    delete_auth "/messages/0"
    
    response.status.should eql(404)
  end

  it "POST /messages; attempts to post a message to yourself" do
    post_auth "/messages", { message: {body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user.id} }
    response.status.should eql(403)
  end

  it "POST /messages; attempts to send a message to someone who does not receive messages" do
    create(:app_setting, app_setting_option_id: 46, user: @user1)
    create(:app_setting, app_setting_option_id: 45, user: @user1)
    
    post_auth "/messages", { message: {body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id} }
    
    response.status.should eql(403)
  end

  it "POST /messages; attempts to send a message to someone who does not receive messages" do
    create(:app_setting, app_setting_option_id: 46, user: @user1)
    
    post_auth "/messages", { message: {body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id} }
    
    response.status.should eql(403)
  end

  it "POST /messages; attempts to send a message to someone who does not receive messages" do
    create(:app_setting, app_setting_option_id: 45, user: @user1)
    
    post_auth "/messages", { message: {body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id} }
    
    response.status.should eql(403)
  end

  it "POST /messages; attempts to send a message when you do not have permission to do so" do
    create(:app_setting, app_setting_option_id: 43, user_role: @user.user_role)
    
    post_auth "/messages", { message: {body: "#{Faker::Lorem.paragraphs(paragraph_count = 1)}", recipient_user_id: @user1.id} }
    
    response.status.should eql(403)
  end

  it "GET /messages; attemps to receive messages, fails because of app setting (41)" do
    create(:app_setting, app_setting_option_id: 41)
    message = create(:message, :random, created_at: Time.now - 1.day, sender_user: @user1, recipient_user: @user)

    get_auth "/messages"
    
    response.status.should eql(403)
  end

  it "GET /messages; attemps to receive messages, fails because of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)
    message = create(:message, :random, created_at: Time.now - 1.day, sender_user: @user1, recipient_user: @user)

    get_auth "/messages"
    
    response.status.should eql(403)
  end

  it "DELETE /messages/conversation/:user_id; attempts to remove conversation, fails because of app setting (41)" do
    create(:app_setting, app_setting_option_id: 41)
    message1 = create(:message, :random, recipient_user: @user, sender_user: @user4)

    delete_auth "/messages/conversation/#{@user4.id}"
    
    response.status.should eql(403)
  end  

  it "GET /messages/conversation/:user_id; attempts to retrieve conversation, fails because of app setting (41)" do
    create(:app_setting, app_setting_option_id: 41)
    message1 = create(:message, :random, recipient_user: @user, sender_user: @user4)

    get_auth "/messages/conversation/#{@user4.id}"
    
    response.status.should eql(403)
  end  

  it "DELETE /messages/conversation/:user_id; attempts to remove conversation, fails because of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)
    message1 = create(:message, :random, recipient_user: @user, sender_user: @user4)

    delete_auth "/messages/conversation/#{@user4.id}"
    
    response.status.should eql(403)
  end  

  it "GET /messages/conversation/:user_id; attempts to retrieve conversation, fails because of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)
    message1 = create(:message, :random, recipient_user: @user, sender_user: @user4)

    get_auth "/messages/conversation/#{@user4.id}"
    
    response.status.should eql(403)
  end

  it "DELETE /message/:id; archives a message to user" do
    create(:app_setting, app_setting_option_id: 41)
    message = create(:message, body: "test message", sender_user: @user1, recipient_user: @user)

    delete_auth "/messages/#{message.id}"
    
    response.status.should eql(403)
  end  

  xit "DELETE /message/:id; attempts to delete a message - app setting (42)" do
    create(:app_setting, app_setting_option_id: 42)
    message = create(:message, body: "test message", sender_user: @user1, recipient_user: @user)

    delete_auth "/messages/#{message.id}"
    
    response.status.should eql(403)
  end

  it "GET /messages; attempts to receive messages fails - app setting (44)" do
    create(:app_setting, app_setting_option_id: 44, user_role: @user.user_role)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (43)" do
    create(:app_setting, app_setting_option_id: 43, user_role: @user.user_role)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (42)" do
    create(:app_setting, app_setting_option_id: 42, user_role: @user.user_role)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (41)" do
    create(:app_setting, app_setting_option_id: 41)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (24)" do
    create(:app_setting, app_setting_option_id: 24, user_role: @user.user_role)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (23)" do
    create(:app_setting, app_setting_option_id: 23)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)

    get_auth "/messages"

    response.status.should eql(403)
  end  

  it "GET /messages; attempts to receive messages fails - app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    get_auth "/messages"

    response.status.should eql(403)
  end

end