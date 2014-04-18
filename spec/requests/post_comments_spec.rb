require 'spec_helper'

describe PostComment do

  before(:all) do
    @user = create(:user)
    @user1 =  create(:user, :random, first_name: "AAA", last_name: "AAA")
    @user2 =  create(:user, :random, first_name: "BBB", last_name: "AAA")
    @user3 =  create(:user, :random, first_name: "CCC", last_name: "CCC")
    @user_author = create(:user, :random, title: "Author")

    @group_open = create(:group, :random, :open)
    @event_open = create(:event, :random, group: @group_open)
    
    @post_event_open = create(:post, event: @event_open, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    @post_group_open = create(:post, group: @group_open, title: "This Is The Title, Group Post", excerpt: 'User Definced Excerpt', body: 'Body of the Group Post', creator: @user_author)
    @event_session_open = create(:event_session, name: "Name of the Open Session", description: "Description of the Open Session", event: @event_open)    

    @group_private = create(:group, :random, :private)
    @event_private = create(:event, :random, group: @group_private)
    
    @post_event_private = create(:post, event: @event_private, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    @post_group_private = create(:post, group: @group_private, title: "This Is The Title, Group Post", excerpt: 'User Definced Excerpt', body: 'Body of the Group Post', creator: @user_author)
    @event_session_private = create(:event_session, name: "Name of the private Session", description: "Description of the private Session", event: @event_private)    

    @group_secret = create(:group, :random, :secret)
    @event_secret = create(:event, :random, group: @group_secret)
    
    @post_event_secret = create(:post, event: @event_secret, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    @post_group_secret = create(:post, group: @group_secret, title: "This Is The Title, Group Post", excerpt: 'User Definced Excerpt', body: 'Body of the Group Post', creator: @user_author)
    @event_session_secret = create(:event_session, name: "Name of the secret Session", description: "Description of the secret Session", event: @event_secret)

    @post_comment_event_open =    create(:post_comment, :random, creator: @user,        user: @user,        post: @post_event_open )
    @post_comment_event_private = create(:post_comment, :random, creator: @user_author, user: @user_author, post: @post_event_private)
    @post_comment_event_secret =  create(:post_comment, :random, creator: @user_author, user: @user_author, post: @post_event_secret)    

    @post_comment_group_open =    create(:post_comment, :random, creator: @user,        user: @user,        post: @post_group_open )
    @post_comment_group_private = create(:post_comment, :random, creator: @user_author, user: @user_author, post: @post_group_private)
    @post_comment_group_secret =  create(:post_comment, :random, creator: @user_author, user: @user_author, post: @post_group_secret)  
  end

  it "GET /post_comments/:id; get 1 post comment record" do
    get_auth "/post_comments/#{@post_comment_event_open.id}"

    response.status.should eq 200
    json.count.should eq(1)
    json["post_comment"]["id"].should eq @post_comment_event_open.id
    json["post_comment"]["body"].should eq @post_comment_event_open.body
    json["post_comment"]["ago"].should eq "0m"
    json["post_comment"]["user"]["id"].should eq @post_comment_event_open.user.id
    json["post_comment"]["post_id"].should eq @post_comment_event_open.post.id
  end

  it "GET /post_comments/post/:id; get all post comments for a post" do
    post = create(:post_comment, :random, post: @post_event_open, user: @user_author, creator: @user_author)

    get_auth "/post_comments/post/#{@post_event_open.id}"

    response.status.should eq 200
    json['post_comments'].count.should eq 2
  end

  it "GET /post_comments/post/:id; attempts to retrieve a post comment, fails because invalid ID" do
    get_auth "/post_comments/post/0"

    response.status.should eq 404
  end

  it "POST /post_comments; attempts to create a new post comment but fails because doesn't include body" do    
    member = create(:group_member, user: @user, group: @group_open)

    post_auth '/post_comments', { post_comment: { body: nil, post_id: @post_group_open.id } }

    response.status.should eq 422
    json["body"].should include("can't be blank")
  end

  it "POST /post_comments; creates a new post comment" do
    create(:event_user, user: @user, event: @event_open)

    post_auth '/post_comments', { post_comment: { body: 'Awesome post dude!', post_id: @post_event_open.id } }

    response.status.should eq 201
    json["post_comment"]["body"].should eq("Awesome post dude!")
  end

  it "POST /post_comments; attempts to create a new post comment but fails because body is too long" do
    create(:event_user, user: @user, event: @event_open)
    
    post_auth '/post_comments', { post_comment: { body: Faker::Lorem.characters(2001), post_id: @post_event_open.id } }
    response.status.should eq 422
    json["body"].should include("is too long (maximum is 2000 characters)")
  end

  it "DELETE /post_comments/:id; attempts to delete your post comment" do
    delete_auth "/post_comments/#{@post_comment_group_open.id}"

    response.status.should eq 204
  end

  it "DELETE /post_comments/:id; attempts to delete someone else's post comment, invalid action" do
    post_comment = create(:post_comment, :random, post: @post_event_secret, user: @user_author, creator: @user_author)

    delete_auth "/post_comments/#{post_comment.id}"
    
    response.status.should eq 403
  end

  it "PATCH /post_comments/:id; updates the body of your post comment" do
    patch_auth "/post_comments/#{@post_comment_group_open.id}", { post_comment: { body: "brand new updated text" } }

    response.status.should eq 204
    updated_post_comment = PostComment.find(@post_comment_group_open.id)
    updated_post_comment.body.should eq("brand new updated text")
  end

  it "PUT /post_comments/:id; updates the body of your post comment" do
    put_auth "/post_comments/#{@post_comment_group_open.id}", { post_comment: { body: "brand new updated text" } }

    response.status.should eq 204
    updated_post_comment = PostComment.find(@post_comment_group_open.id)
    updated_post_comment.body.should eq("brand new updated text")
  end

  it "PATCH /post_comments/:id; updates the body of your post comment, fails because body is too long" do
    patch_auth "/post_comments/#{@post_comment_group_open.id}", { post_comment: { body: Faker::Lorem.characters(2001) } }
    
    response.status.should eq 422
  end

  it "PATCH /post_comments/:id; updates the body of someone else's post comment, invalid action" do
    post_comment = create(:post_comment, :random, post: @post_event_secret, user: @user_author, creator: @user_author)

    patch_auth "/post_comments/#{post_comment.id}", { post_comment: { body: "Coffee Pot" } }
    response.status.should eq 403
  end

  it "POST /post_comments; attempts to create a post comment on a secret event post, user is not member, is not user; should 404." do
    post_auth '/post_comments', { post_comment: { body: 'Awesome post dude!', post_id: @post_event_secret.id } } 
    
    response.status.should eql(404)
  end

  it "POST /post_comments; attempts to create a post comment on an open group post but fails because user isn't group member" do
    post_auth '/post_comments', { post_comment: { body: 'Awesome post dude!', post_id: @post_group_open.id } } 
    
    response.status.should eql(403)
  end

  it "POST /post_comments; attempts to create a post comment on a private group post but fails because user isn't group member" do
  post_auth '/post_comments', { post_comment: { body: 'Awesome post dude!', post_id: @post_group_private.id } } 
  
  response.status.should eql(404)
  end

  it "GET /post_comments/:id; checks on post_comment in secret event, not member, not user, should 404" do
    get_auth "/post_comments/#{@post_comment_event_secret.id}"
    
    response.status.should eql(404)
  end

  it "GET /post_comments/:id; checks on post_comment in secret group, not member, should 404" do
    get_auth "/post_comments/#{@post_comment_group_secret.id}"
    
    response.status.should eql(404)
  end

  it "GET /post_comments/:id; checks on post_comment in private event, not member, not user, should 404" do
    get_auth "/post_comments/#{@post_comment_event_private.id}"
    
    response.status.should eql(404)    
  end

  it "GET /post_comments/:id; checks on post_comment in private group, not member, should 404" do
    get_auth "/post_comments/#{@post_comment_group_private.id}"

    response.status.should eql(404)
  end

  it "GET /post_comments/post/:id; show comments event though making new comments are turned off at App level (95)" do
    create(:app_setting, app_setting_option_id: 95)

    get_auth "/post_comments/post/#{@post_group_open.id}"
    
    response.status.should eq 200
  end

  it "GET /post_comments/post/:id; show comments event though making new comments are turned off at UserRole level (98)" do
    create(:app_setting, app_setting_option_id: 98, user_role: @user.user_role)

    get_auth "/post_comments/post/#{@post_group_open.id}"
    
    response.status.should eq 200
  end

  it "GET /post_comments/post/:id; show comments event though making new comments are turned off at UserRole level (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)

    get_auth "/post_comments/post/#{@post_group_open.id}"
    
    response.status.should eq 200
  end

  it "POST /post_comments; try to create a new post comment, fails because comments are turned off at App level (95)" do
    create(:app_setting, app_setting_option_id: 95)

    post_auth '/post_comments', { post_comment: { body: 'Awesome post dude!', post_id: @post_group_open.id } }
    
    response.status.should eq 403
  end

  it "PATCH /post_comments; try to update a post comment, fails because comments are turned off at App level (95)" do
    create(:app_setting, app_setting_option_id: 95)

    patch_auth "/post_comments/#{@post_comment_group_open.id}", { post_comment: { body: 'Awesome post dude!'} }
    
    response.status.should eq 403
  end  

  it "PATCH /post_comments; try to update a post comment, fails because comment edits are turned off at App level (103)" do
    create(:app_setting, app_setting_option_id: 103)

    patch_auth "/post_comments/#{@post_comment_group_open.id}", { post_comment: { body: 'Awesome post dude!'} }
    
    response.status.should eq 403
  end  

  it "PUT /post_comments; try to update a post comment, fails because comment edits are turned off at App level (103)" do
    create(:app_setting, app_setting_option_id: 103)

    put_auth "/post_comments/#{@post_comment_group_open.id}", { post_comment: { body: 'Awesome post dude!'} }
    
    response.status.should eq 403
  end  

  it "DELETE /post_comments; try to update a post comment, fails because comment edits are turned off at App level (103)" do
    create(:app_setting, app_setting_option_id: 103)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end  

  xit "DELETE /post_comments; try to update a post comment, fails, app setting (104)" do
    create(:app_setting, app_setting_option_id: 104)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end  

  it "DELETE /post_comments; try to update a post comment, fails, app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end  

  it "DELETE /post_comments; try to update a post comment, fails, app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end  

  it "DELETE /post_comments; try to update a post comment, fails, app setting (95)" do
    create(:app_setting, app_setting_option_id: 95)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end  

  it "DELETE /post_comments; try to update a post comment, fails, app setting (98)" do
    create(:app_setting, app_setting_option_id: 98, user_role: @user.user_role)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end  

  it "DELETE /post_comments; try to update a post comment, fails, app setting (103)" do
    create(:app_setting, app_setting_option_id: 103)

    delete_auth "/post_comments/#{@post_comment_group_open.id}"
    
    response.status.should eq 403
  end

end