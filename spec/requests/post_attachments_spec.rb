require 'spec_helper'

describe 'PostAttachments' do

  before(:all) do
    @user = create(:user)
    @user_author = create(:user, :random, title: "Author")

    @group_open = create(:group, :random, :open)
    @event_open = create(:event, :random, group: @group_open)
    @event_session1 = create(:event_session, name: "Name of the Open Session", description: "Description of the Open Session", event: @event_open)    
    @event_session2 = create(:event_session, name: "Name of the Open Session", description: "Description of the Open Session", event: @event_open)    
    
    @post_event = create(:post, event: @event_open, body: 'Body of the Event Post', creator: @user_author)
    @post_event_mine = create(:post, event: @event_open, body: 'Body of the Event Post', creator: @user)
    @post_group = create(:post, group: @group_open, body: 'Body of the Group Post', creator: @user_author)
    @post_group_mine = create(:post, group: @group_open, body: 'Body of the Group Post', creator: @user)
    @post_event_session = create(:post, event_session: @event_session1, body: 'Body of the Event Session Post', creator: @user_author)
    @post_event_session_mine = create(:post, event_session: @event_session2, body: 'Body of the Event Session Post', creator: @user)
  end

  it "POST /post_attachments; attempts to create a post attachment for an event post authored by current user" do
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(201)
    json["post_attachment"]["post_id"].should eq @post_event_mine.id
    json["post_attachment"]["url"].should eq 'my_attachment.com'
    json["post_attachment"]["created_by"].should eq @user.id
    json["post_attachment"]["ago"].should eq "0m"
  end

  it "POST /post_attachments; attempts to create a post attachment for an event post not authored by current user, forbidden" do
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an event_session post authored by current user" do
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_session_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(201)
    json["post_attachment"]["post_id"].should eq @post_event_session_mine.id
    json["post_attachment"]["url"].should eq 'my_attachment.com'
    json["post_attachment"]["created_by"].should eq @user.id
    json["post_attachment"]["ago"].should eq "0m"
  end

  it "POST /post_attachments; attempts to create a post attachment for an event_session post not authored by current user, forbidden" do
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_session.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an group post authored by current user" do
    post_auth '/post_attachments', { post_attachment: { post_id: @post_group_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(201)
    json["post_attachment"]["post_id"].should eq @post_group_mine.id
    json["post_attachment"]["url"].should eq 'my_attachment.com'
    json["post_attachment"]["created_by"].should eq @user.id
    json["post_attachment"]["ago"].should eq "0m"
  end

  it "POST /post_attachments; attempts to create a post attachment for an group post not authored by current user, forbidden" do
    post_auth '/post_attachments', { post_attachment: { post_id: @post_group.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "PATCH /post_attachments; attempts to update a post attachment made by current user" do
    post_attachment = create(:post_attachment, post: @post_event_mine, url: 'my_attachment.com', creator: @user)
    patch_auth "/post_attachments/#{post_attachment.id}", { post_attachment: { url: 'updated_attachment.com' } }

    response.status.should eq(204)
    PostAttachment.find(post_attachment.id).url.should eq 'updated_attachment.com'
  end

  it "PATCH /post_attachments; attempts to update a post attachment made by another user, forbidden" do
    post_attachment = create(:post_attachment, post: @post_event, url: 'my_attachment.com', creator: @user_author)
    patch_auth "/post_attachments/#{post_attachment.id}", { post_attachment: { url: 'updated_attachment.com' } }

    response.status.should eq(403)
    PostAttachment.find(post_attachment.id).url.should eq 'my_attachment.com'
  end

  it "DELETE /post_attachments/:id; attempts to delete a post attachment made by current user" do
    post_attachment = create(:post_attachment, post: @post_event_mine, url: 'my_attachment.com', creator: @user)
    delete_auth "/post_attachments/#{post_attachment.id}"

    response.status.should eq(204)
  end

  it "DELETE /post_attachments/:id; attempts to delete a post attachment made by another user, forbidden" do
    post_attachment = create(:post_attachment, post: @post_event, url: 'my_attachment.com', creator: @user_author)
    delete_auth "/post_attachments/#{post_attachment.id}"

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to add attachment to post - app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end     

  it "POST /post_attachments; attempts to add attachment to post - app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end    

  it "POST /post_attachments; attempts to add attachment to post - app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end  

  it "POST /post_attachments; attempts to add attachment to post - app setting (76)" do
    create(:app_setting, app_setting_option_id: 76, user_role: @user.user_role)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end  

  it "POST /post_attachments; attempts to create a post attachment for an event post authored by current user, attachments turned off for event - app setting (80)" do
    create(:app_setting, app_setting_option_id: 80, event: @event_open)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end  

  it "POST /post_attachments; attempts to create a post attachment for an event post authored by current user, attachments turned off for event - app setting (80)" do
    create(:app_setting, app_setting_option_id: 80, event: @event_open)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an event session post authored by current user, attachments turned off for event - app setting (80)" do
    create(:app_setting, app_setting_option_id: 80, event: @event_open)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_session_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an group post authored by current user, attachments turned off for group - app setting (81)" do
    create(:app_setting, app_setting_option_id: 81, group: @group_open)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_group_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an group post authored by current user, attachments turned off for user role - app setting (82)" do
    create(:app_setting, app_setting_option_id: 82, user_role: @user.user_role)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_group_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an event post authored by current user, attachments turned off for user role - app setting (82)" do
    create(:app_setting, app_setting_option_id: 82, user_role: @user.user_role)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_session_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

  it "POST /post_attachments; attempts to create a post attachment for an event post authored by current user, attachments turned off for user role - app setting (82)" do
    create(:app_setting, app_setting_option_id: 82, user_role: @user.user_role)
    post_auth '/post_attachments', { post_attachment: { post_id: @post_event_mine.id, url: 'my_attachment.com' } }

    response.status.should eq(403)
  end

end