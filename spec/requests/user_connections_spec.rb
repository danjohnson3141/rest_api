require 'spec_helper'

describe 'UserConnections' do

  before(:all) do
    @user = create(:user)
    @recipient_user = create(:user, :random)
  end

  it "POST /user_connections; create new connection" do
    post_auth '/user_connections', { user_connection: { recipient_user_id: @recipient_user.id } }
    
    response.status.should eq 201
    json["user_connection"]["user"]["id"].should eq @recipient_user.id
  end

  it "POST /user_connections; attempts to create new connection to oneself" do
    post_auth '/user_connections', { user_connection: { recipient_user_id: @user.id } }
    
    response.status.should eq 403
  end

  it "POST /user_connections; attempts to create a new connection for other users, uses current user" do
    sender_user = create(:user, :random)

    post_auth '/user_connections', { user_connection: { sender_user_id: sender_user.id, recipient_user_id: @recipient_user.id } }
    
    response.status.should eq 201
    json["user_connection"]["user"]["id"].should eq @recipient_user.id
  end

  it "POST /user_connections; attempts to create a connection when pending connection already exists" do
    user_connection = create(:user_connection, sender_user: @user, recipient_user: @recipient_user, is_approved: false)

    post_auth '/user_connections', { user_connection: { sender_user: @user, recipient_user_id: @recipient_user.id } }
    
    response.status.should eq 422
    json["sender_user_id"].should include('has already been taken')
  end

  it "POST /user_connections; attempts to create a connection when approved connection already exists"  do
    user_connection = create(:user_connection, sender_user: @user, recipient_user: @recipient_user, is_approved: true)

    post_auth '/user_connections', { user_connection: { sender_user: @user, recipient_user_id: @recipient_user.id } }
    
    response.status.should eq 422
    json["sender_user_id"].should include('has already been taken')
  end

  it "POST /user_connections; create a new connection, fails because recipient doesn't exist" do
    post_auth '/user_connections', { user_connection: { sender_user: @user, recipient_user_id: 0 } }
    
    response.status.should eq 404
  end

  it "PATCH /user_connections/:id; approve a connection" do
    sender_user = create(:user, :random)
    user_connection = create(:user_connection, sender_user: sender_user, recipient_user: @user, is_approved: false)
    UserConnection.find(user_connection.id).is_approved.should eq(false)

    patch_auth "/user_connections/#{user_connection.id}"
    
    response.status.should eql(204)
    UserConnection.find(user_connection.id).is_approved.should eq(true)
    Notification.where(user: sender_user, user_connection: user_connection).first.should be
  end

  it "PATCH /user_connections/:id; attempts to have sender approve a connection" do
    user_connection = create(:user_connection, sender_user: @user, recipient_user: @recipient_user, is_approved: false)
    
    UserConnection.find(user_connection.id).is_approved.should eq(false)
    patch_auth "/user_connections/#{user_connection.id}"
    response.status.should eql(403)
  end

  it "PATCH /user_connections/:id; attempts to approve a connection that has no part of" do
    sender_user = create(:user, :random)
    user_connection = create(:user_connection, sender_user: sender_user, recipient_user: @recipient_user)

    patch_auth "/user_connections/#{user_connection.id}"
    
    response.status.should eql(403)
  end

  it "PATCH /user_connections/:id; approve a connection that doesn't exists" do
    patch_auth "/user_connections/0"
    
    response.status.should eql(404)
  end

  it "DELETE /user_connections/:id; sender attempts to delete a pending connection" do
    user_connection = create(:user_connection, sender_user: @user, recipient_user: @recipient_user, is_approved: false )

    delete_auth "/user_connections/#{user_connection.id}"
    
    response.status.should eql(403)
  end

  it "DELETE /user_connections/:id; recipient deletes an existing approved connection" do
    sender_user = create(:user, :random)
    user_connection = create(:user_connection, sender_user: sender_user, recipient_user: @user, is_approved: true)

    delete_auth "/user_connections/#{user_connection.id}"
    
    response.status.should eql(204)
  end

  it "DELETE /user_connections/:id; recipient deletes a pending connection" do
    sender_user = create(:user, :random)
    user_connection = create(:user_connection, sender_user: sender_user, recipient_user: @user, is_approved: true)

    delete_auth "/user_connections/#{user_connection.id}"
    
    response.status.should eql(204)
  end

  it "DELETE /user_connections/:id; attempts to delete connection has no part of" do
    sender_user = create(:user, :random)
    user_connection = create(:user_connection, sender_user: sender_user, recipient_user: @recipient_user)

    delete_auth "/user_connections/#{user_connection.id}"
    
    response.status.should eql(403)
  end

  it "DELETE /user_connections/:id; attempts to delete an incorrect connection" do
    delete_auth "/user_connections/0"
    
    response.status.should eql(404)
  end

  it "GET /users/connections/:user_id; get your connection records" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    user3 = create(:user, :random)
    user_connection1 = create(:user_connection, sender_user: @user, recipient_user: user2, is_approved: true)
    user_connection2 = create(:user_connection, sender_user: user3, recipient_user: @user, is_approved: true)

    get_auth "/users/connections/#{@user.id}"
    
    response.status.should eql(200)
    json["users"].count.should eq(2)
    json["users"][0]["id"].should eq user3.id
    json["users"][0]["connection_status"]["id"].should eq user_connection2.id
    json["users"][0]["connection_status"]["is_approved"].should eq true
    json["users"][0]["connection_status"]["is_approver"].should eq true
    json["users"][1]["id"].should eq user2.id
    json["users"][1]["connection_status"]["id"].should eq user_connection1.id
    json["users"][1]["connection_status"]["is_approved"].should eq true
    json["users"][1]["connection_status"]["is_approver"].should eq false
  end

  it "GET /users/connections/:user_id; get your connection records" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    user3 = create(:user, :random)
    user_connection1 = create(:user_connection, sender_user: @user, recipient_user: user2, is_approved: true)
    user_connection2 = create(:user_connection, sender_user: user3, recipient_user: @user, is_approved: false)

    get_auth "/users/connections/#{@user.id}"
    
    response.status.should eql(200)
    json["users"].count.should eq(1)
    json["users"][0]["id"].should eq user2.id
    json["users"][0]["connection_status"]["id"].should eq user_connection1.id
    json["users"][0]["connection_status"]["is_approved"].should eq true
    json["users"][0]["connection_status"]["is_approver"].should eq false
  end

  it "GET /users/connections/:user_id; get another users connections, show my connections turned off at User level" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    user3 = create(:user, :random)
    create(:user_connection, sender_user: user1, recipient_user: user2, is_approved: true)
    create(:user_connection, sender_user: user1, recipient_user: user3, is_approved: true)
    create(:user_connection, sender_user: user1, recipient_user: @user, is_approved: true)
    create(:app_setting, app_setting_option_id: 51, user: user1)
    
    get_auth "/users/connections/#{user1.id}"
    
    response.status.should eql(403)
  end

  it "GET /users/connections/:user_id; another user's connection records" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    user3 = create(:user, :random)
    user_connection1 = create(:user_connection, sender_user: @user, recipient_user: user1, is_approved: true)
    user_connection2 = create(:user_connection, sender_user: @user, recipient_user: user2, is_approved: true)
    user_connection3 = create(:user_connection, sender_user: user2, recipient_user: user3, is_approved: true)

    get_auth "/users/connections/#{user2.id}"
    
    response.status.should eql(200)
    json["users"].count.should eq(2)
    json.to_s.should include user3.id.to_s, @user.id.to_s
  end

  it "GET /users/connections/:user_id; get 0 user_connections records for a user" do
    get_auth "/users/connections/#{@user.id}"
    
    response.status.should eql(200)
    json["users"].count.should eq(0)
  end

  it "GET /user_connections/pending; get your pending connection records" do
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    user3 = create(:user, :random)
    user_connection1 = create(:user_connection, sender_user: @user, recipient_user: user2, is_approved: false, created_at: Time.now - 10.minute)
    user_connection2 = create(:user_connection, sender_user: user3, recipient_user: @user, is_approved: false, created_at: Time.now - 20.minute)
    user_connection3 = create(:user_connection, sender_user: user2, recipient_user: @user, is_approved: true, created_at: Time.now - 30.minute)

    get_auth "/user_connections/pending"

    response.status.should eql(200)
    # binding.pry
    json["users"].count.should eq(2)
    json["users"][0]["id"].should eq user3.id
    json["users"][0]["connection_status"]["id"].should eq user_connection2.id
    json["users"][0]["connection_status"]["is_approved"].should eq false
    json["users"][0]["connection_status"]["is_approver"].should eq true
    json["users"][1]["id"].should eq user2.id
    json["users"][1]["connection_status"]["id"].should eq user_connection1.id
    json["users"][1]["connection_status"]["is_approved"].should eq false
    json["users"][1]["connection_status"]["is_approver"].should eq false
  end

  it "POST /user_connections; connection permission disabled at App level" do
    create(:app_setting, app_setting_option_id: 21)

    post_auth "/user_connections", { user_connection: { recipient_user_id: @recipient_user.id } }
    
    response.status.should eql(403)
  end

  it "POST /user_connections; attempts to create a connection, fails because of app setting (47)" do
    create(:app_setting, app_setting_option_id: 47)

    post_auth "/user_connections", { user_connection: { recipient_user_id: @recipient_user.id } }
    
    response.status.should eql(403)
  end

  it "POST /user_connections; connection permission disabled at UserRole level" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    
    post_auth "/user_connections", { user_connection: { recipient_user_id: @recipient_user.id } }
    
    response.status.should eql(403)
  end

  it "POST /user_connections; connection permission disabled at UserRole level" do
    create(:app_setting, app_setting_option_id: 48, user_role: @user.user_role)
    
    post_auth "/user_connections", { user_connection: { recipient_user_id: @recipient_user.id } }
    
    response.status.should eql(403)
  end

end
