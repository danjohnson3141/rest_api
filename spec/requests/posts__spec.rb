require 'spec_helper'

describe 'Posts' do

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
  end

  it "GET /posts/:id; returns post for an event_session. Author should be event_session_speaker. Event session_id should be returned." do  
    event_speaker = create(:event_speaker, first_name: @user_author.first_name, last_name: @user_author.last_name, event_session: @event_session_open, user: @user_author)
    post_event_open_session = create(:post, event_session: @event_session_open, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)

    get_auth "/posts/#{post_event_open_session.id}"
    response.status.should eql(200)
    json["post"]["excerpt"].should eq post_event_open_session.excerpt
    json["post"]["title"].should eq post_event_open_session.title
    json["post"]["authors"].first["id"].should eq @user_author.id
    json["post"]["authors"].first["first_name"].should eq @user_author.first_name
    json["post"]["authors"].first["last_name"].should eq @user_author.last_name
    json["post"]["authors"].first["photo"].should eq @user_author.photo
    json["post"]["event_session_id"].should eq @event_session_open.id
  end

  it "GET /posts/:id; returns post for an event_session post. Author should be a moderator on an event_session_speaker(s). Event session id should be returned." do
    post_event_open_session = create(:post, event_session: @event_session_open, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user_author)
    event_speaker = create(:event_speaker, :random, event_session: @event_session_open, moderator: true)

    get_auth "/posts/#{post_event_open_session.id}"

    response.status.should eql(200)
    json["post"]["excerpt"].should eq post_event_open_session.excerpt
    json["post"]["title"].should eq post_event_open_session.title
    json["post"]["body"].should eq post_event_open_session.body
    json["post"]["authors"].first["id"].should eq event_speaker.user_id
    json["post"]["authors"].first["first_name"].should eq event_speaker.first_name
    json["post"]["authors"].first["last_name"].should eq event_speaker.last_name
    json["post"]["authors"].first["photo"].should eq event_speaker.user.photo
    json["post"]["authors"].first["moderator"].should eq true
    json["post"]["event_session_id"].should eq @event_session_open.id
  end

  it "GET /posts/:id; checks on post in private group, not member, should 404" do
    get_auth "/posts/#{@post_group_private.id}"

    response.status.should eql(404)
  end

  it "GET /posts/:id; checks on post in private group, is member, returns post" do
    group_member_private = create(:group_member, user: @user, group: @group_private)

    get_auth "/posts/#{@post_group_private.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_private.id
  end

  it "GET /posts/:id; checks on post in private event, not member, not user, should 404" do
    get_auth "/posts/#{@post_event_private.id}"

    response.status.should eql(404)
  end

  it "GET /posts/:id; checks on post in private event, is member, not user, returns post" do
    group_member_prvate = create(:group_member, user: @user, group: @group_private)

    get_auth "/posts/#{@post_event_private.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_private.id
  end

  it "GET /posts/:id; checks on post of private event, not member, is user, returns post" do
    event_user_private = create(:event_user, user: @user, event: @event_private)

    get_auth "/posts/#{@post_event_private.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_private.id
  end

  it "GET /posts/:id; checks on post in secret group, not member, should 404" do
    get_auth "/posts/#{@post_group_secret.id}"

    response.status.should eql(404)
  end

  it "GET /posts/:id; checks on post in secret group, is member, returns post" do
    secret_member = create(:group_member, user: @user, group: @group_secret)

    get_auth "/posts/#{@post_group_secret.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_secret.id
  end

  it "GET /posts/:id; checks on post in secret event, not member, not user, should 404" do
    get_auth "/posts/#{@post_event_secret.id}"

    response.status.should eql(404)
  end

  it "GET /posts/:id; checks on post in secret event, is member, not user, returns post" do
    secret_member = create(:group_member, user: @user, group: @group_secret)

    get_auth "/posts/#{@post_event_secret.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_secret.id
  end

  it "GET /posts/:id; checks on post of secret event, not member, is user, returns post" do
    secret_event_user = create(:event_user, user: @user, event: @event_secret)

    get_auth "/posts/#{@post_event_secret.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_secret.id
  end  

  it "GET /posts/:id; checks on post of secret event, not member, is user, returns post" do
    secret_event_user = create(:event_user, user: @user, event: @event_secret)

    get_auth "/posts/#{@post_event_secret.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_secret.id
  end

  it "GET /posts/:id; checks on post in open group, not member, not event_user," do
    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
  end

  it "GET /posts/:id; checks on post in open group, is member, returns post" do
    group_member_open = create(:group_member, user: @user, group: @group_open)

    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
  end

  it "GET /posts/:id; checks on post in open event, not member, not user, returns post" do
    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
  end    

  it "GET /posts/:id; checks on post in open event, is member, not user, returns post" do
    group_member_open = create(:group_member, user: @user, group: @group_open)

    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
  end   

  it "GET /posts/:id; checks on post of open event, not member, is user, returns post" do
    event_user_open = create(:event_user, user: @user, event: @event_open)

    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
  end

  it "POST /posts; attempts to create an event post but fails because user isn't event user" do
    post_auth '/posts', { post: { body: 'post', event_id: @event_open.id } }

    response.status.should eq(403)
  end

  it "POST /posts; attempts to create a group post but fails because user isn't group member" do
    post_auth '/posts', { post: { body: 'post', group_id: @group_open.id } }

    response.status.should eq(403)
  end

  it "POST /posts; attempts to create an event post but fails because doesn't include body" do
    event_user_open = create(:event_user, event: @event_open, user: @user)

    post_auth '/posts', { post: { body: nil, event_id: @event_open.id } }

    response.status.should eq(422)
    json["body"].should include("can't be blank")
  end

  it "POST /posts; attempts to create a post; fails because too many subjects passed" do
    event_user_open = create(:event_user, event: @event_open, user: @user)
    group_member_open = create(:group_member, user: @user, group: @group_open)

    post_auth '/posts', { post: { body: 'Body', group_id: @group_open.id, event_id: @event_open.id } }

    response.status.should eq(422)
  end

  it "POST /posts; attempts to create a post; fails because no event or group passed" do
    post_auth '/posts', { post: { body: 'Body' } }

    response.status.should eq(422)
  end

  it "POST /posts; create an event post w/ title." do
    event_user_open = create(:event_user, event: @event_open, user: @user)

    post_auth '/posts', { post: { title: "Titles are cool", body: 'A teapot is a vessel used for steeping tea leaves.', body_markdown: 'A *teapot* is a vessel used for **steeping** tea leaves.', excerpt: 'vessel steeping', thumbnail_teaser_photo: 'www.example.com/teaser.bmp', event_id: @event_open.id } }

    response.status.should eq(201)
    json["post"]["title"].should eq("Titles are cool")
    json["post"]["body"].should eq("A teapot is a vessel used for steeping tea leaves.")
    json["post"]["event"]["id"].should eq @event_open.id
    json["post"]["authors"][0]["id"].should eq @user.id
  end

  it "POST /posts; create an event post w/o title." do
    event_user_open = create(:event_user, event: @event_open, user: @user)

    post_auth '/posts', { post: { body: 'A teapot is a vessel used for steeping tea leaves.', body_markdown: 'A *teapot* is a vessel used for **steeping** tea leaves.', excerpt: 'vessel steeping', thumbnail_teaser_photo: 'www.example.com/teaser.bmp', event_id: @event_open.id } }

    response.status.should eq(201)
    json["post"]["title"].should eq(nil)
    json["post"]["body"].should eq("A teapot is a vessel used for steeping tea leaves.")
    json["post"]["event"]["id"].should eq @event_open.id
    json["post"]["authors"][0]["id"].should eq @user.id
  end

  it "POST /posts; create a group post w/ title" do
    group_member_open = create(:group_member, user: @user, group: @group_open)

    post_auth '/posts', { post: { title: 'Make it so!', body: 'A teapot is a vessel used for steeping tea leaves.', body_markdown: 'A *teapot* is a vessel used for **steeping** tea leaves.', excerpt: 'vessel steeping', thumbnail_teaser_photo: 'www.example.com/teaser.bmp', group_id: @group_open.id } }

    response.status.should eq(201)
    json["post"]["title"].should eq('Make it so!')
    json["post"]["body"].should eq("A teapot is a vessel used for steeping tea leaves.")
    json["post"]["group"]["id"].should eq @group_open.id
    json["post"]["authors"][0]["id"].should eq @user.id
  end

  it "POST /posts; create a group post w/o title" do
    group_member_open = create(:group_member, user: @user, group: @group_open)

    post_auth '/posts', { post: { body: 'A teapot is a vessel used for steeping tea leaves.', body_markdown: 'A *teapot* is a vessel used for **steeping** tea leaves.', excerpt: 'vessel steeping', thumbnail_teaser_photo: 'www.example.com/teaser.bmp', group_id: @group_open.id } }

    response.status.should eq(201)
    json["post"]["title"].should eq(nil)
    json["post"]["body"].should eq("A teapot is a vessel used for steeping tea leaves.")
    json["post"]["group"]["id"].should eq @group_open.id
    json["post"]["authors"][0]["id"].should eq @user.id
  end

  it "POST /posts; attempts to create an event post but fails because title is too long" do
    event_user_open = create(:event_user, event: @event_open, user: @user)   

    post_auth '/posts', { post: { title: Faker::Lorem.characters(256), body: 'Post Body', event_id: @event_open.id } }
    
    response.status.should eq(422)
    json["title"].should include("is too long (maximum is 255 characters)")
  end

  it "GET /posts/:id; get 1 post record" do
    post = create(:post, event: @event_open, creator: @user_author)

    get_auth "/posts/#{post.id}"

    response.status.should eq(200)
    json.count.should eq(1)
    json["post"]["id"].should eq post.id
  end

  it "GET /posts/:id; get 1 post record, expect view count to go up by 1" do
    post = create(:post, :group, view_count: 5)

    get_auth "/posts/#{post.id}"

    response.status.should eq(200)
    json.count.should eq(1)
    json["post"]["id"].should eq post.id
    json["post"]["view_count"].should eq post.view_count + 1
  end

  it "GET /posts/:id; get a single post, excerpt should be first 200 chars of body when excerpt is blank" do
    post = create(:post, body: Faker::Lorem.characters(300), group: @group_open, creator: @user_author)

    get_auth "/posts/#{post.id}"

    response.status.should eql(200)
    json["post"]["body"].should eq post.body
    json["post"]["excerpt"].should eq nil
    json["post"]["generated_excerpt"].should eq post.generated_excerpt
  end

  it "GET /posts/:id; get a single posts, excerpt should be first 200 chars of body when excerpt is blank" do
    post = create(:post, excerpt: 'my own excerpt', body: Faker::Lorem.characters(300), group: @group_open, creator: @user_author)

    get_auth "/posts/#{post.id}"

    response.status.should eql(200)
    json["post"]["body"].should eq post.body
    json["post"]["excerpt"].should eq 'my own excerpt'
    json["post"]["generated_excerpt"].should eq post.generated_excerpt
  end

  it "DELETE /posts/:id; attempts to delete your post" do
    post = create(:post, :random, :event, creator: @user)

    delete_auth "/posts/#{post.id}"

    response.status.should eq(204)
  end

  it "DELETE /posts/:id; attempts to delete someone else's post, invalid action" do
    post = create(:post, :random, :event, creator: @user_author)

    delete_auth "/posts/#{post.id}"

    response.status.should eq(403)
  end

  it "PATCH /posts/:id; updates the title of your post" do
    event_user = create(:event_user, event: @event_open, user: @user)
    post = create(:post, title: 'Teapot', body: 'A teapot is a vessel used for steeping tea leaves.', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}",
    { post:
      { title: "Coffee Pot",
        body: "A covered container with a spout, in which coffee is made or served.",
        body_markdown: "A **covered** *container* with a spout, in which coffee is made or served.",
        excerpt: "covered container",
        thumbnail_teaser_photo: "www.example.com/new_photo.png"
        }
      }

    response.status.should eq(204)
    updated_post = Post.find(post.id)
    updated_post.title.should eq("Coffee Pot")
  end

  it "PATCH /posts/:id; adds a title to the post" do
    post = create(:post, body: 'A teapot is a vessel used for steeping tea leaves.', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}",
    { post:
      { title: "Adding This",
        body: "A covered container with a spout, in which coffee is made or served.",
        body_markdown: "A **covered** *container* with a spout, in which coffee is made or served.",
        excerpt: "covered container",
        thumbnail_teaser_photo: "www.example.com/new_photo.png"
        }
      }

    response.status.should eq(204)
    updated_post = Post.find(post.id)
    updated_post.title.should eq("Adding This")
  end

  it "PATCH /posts/:id; removes the title to the post" do
    post = create(:post, title: 'Teapot', body: 'A teapot is a vessel used for steeping tea leaves.', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}",
    { post:
      { title: nil,
        body: "A covered container with a spout, in which coffee is made or served.",
        body_markdown: "A **covered** *container* with a spout, in which coffee is made or served.",
        excerpt: "covered container",
        thumbnail_teaser_photo: "www.example.com/new_photo.png"
        }
      }

    response.status.should eq(204)
    updated_post = Post.find(post.id)
    updated_post.title.should eq nil
  end  

  it "PATCH /posts/:id; attempts to remove the body to the post" do
    post = create(:post, title: 'Teapot', body: 'A teapot is a vessel used for steeping tea leaves.', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}",
    { post:
      { body: nil,
        body_markdown: "A **covered** *container* with a spout, in which coffee is made or served.",
        excerpt: "covered container",
        thumbnail_teaser_photo: "www.example.com/new_photo.png"
        }
      }

    response.status.should eq(422)
  end

  it "PATCH /posts/:id; updates the title of your post, fails because title is too long" do
    post = create(:post, title: 'Teapot', body: 'A teapot is a vessel used for steeping tea leaves', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: Faker::Lorem.characters(256) } }

    response.status.should eq(422)
    updated_post = Post.find(post.id)
    updated_post.title.should eq("Teapot")
  end

  it "PATCH /posts/:id; updates the title of someone else's post, invalid action" do
    post = create(:post, event: @event_open, title: 'Teapot', body: 'A teapot is a vessel used for steeping tea leaves', creator: @user_author)

    patch_auth "/posts/#{post.id}", { post: { title: "Coffee Pot" } }
    response.status.should eq(403)
  end

  it "GET /posts/:id; checks on post - can like, showing count" do
    create(:post_like, post: @post_group_open, user: @user2, created_at: Time.now - 5.minutes)

    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
    json["post"]["like_count"].should eq 1
    json["post"]["can_like"].should eq true    
  end

  it "GET /posts/:id; checks on post - can_delete turned on" do
    post = create(:post, event: @event_open, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user)
    get_auth "/posts/#{post.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq post.id
    json["post"]["can_delete"].should eq true
  end

  it "GET /posts/:id; checks on post - can_comment turned on" do
    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
    json["post"]["can_comment"].should eq true
  end

  it "GET /posts/:id; checks on post - like_count turned off - app setting (114)" do
    create(:post_like, post: @post_group_open, user: @user2, created_at: Time.now - 5.minutes)
    create(:app_setting, app_setting_option_id: 114, user_role: @user.user_role)

    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
    json["post"]["like_count"].should eq false
  end

  it "GET /posts/:id; checks on post - can_like turned off - app setting (112)" do
    create(:post_like, post: @post_group_open, user: @user2, created_at: Time.now - 5.minutes)
    create(:app_setting, app_setting_option_id: 112, user_role: @user.user_role)

    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
    json["post"]["can_like"].should eq false
  end

  it "GET /posts/:id; checks on post - can_like turned off - app setting (111)" do
    create(:post_like, post: @post_group_open, user: @user2, created_at: Time.now - 5.minutes)
    create(:app_setting, app_setting_option_id: 111, group: @group_open)

    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
    json["post"]["can_like"].should eq false
  end

  it "GET /posts/:id; checks on post - can_like turned off - app setting (110)" do
    create(:post_like, post: @post_event_open, user: @user2, created_at: Time.now - 5.minutes)
    create(:app_setting, app_setting_option_id: 110, event: @event_open)

    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
    json["post"]["can_like"].should eq false
  end

  it "GET /posts/:id; checks on post - can_comment turned off - app setting (98)" do
    create(:app_setting, app_setting_option_id: 98, user_role: @user.user_role)

    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
    json["post"]["can_comment"].should eq false
  end

  it "GET /posts/:id; checks on post - can_comment turned off - app setting (96)" do
    create(:app_setting, app_setting_option_id: 96, event: @event_open)

    get_auth "/posts/#{@post_event_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_event_open.id
    json["post"]["can_comment"].should eq false
  end

  it "GET /posts/:id; checks on post - can_comment turned off - app setting (97)" do
    create(:app_setting, app_setting_option_id: 97, group: @group_open)

    get_auth "/posts/#{@post_group_open.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq @post_group_open.id
    json["post"]["can_comment"].should eq false
  end

  it "GET /posts/:id; checks on post - can_delete turned off - app setting (90)" do
    create(:app_setting, app_setting_option_id: 90, user_role: @user.user_role)
    post = create(:post, event: @event_open, title: "This Is The Title, Event Post", excerpt: 'User Definced Excerpt', body: 'Body of the Event Post', creator: @user)
    get_auth "/posts/#{post.id}"

    response.status.should eql(200)
    json["post"]["id"].should eq post.id
    json["post"]["can_delete"].should eq false
  end

    it "POST /posts; attempts to create an event post but fails, fails - app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)
    post_auth '/posts', { post: { body: 'Post Body', event_id: @event_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create an event post but fails, fails because of app setting (74)" do
    create(:app_setting, app_setting_option_id: 74, event: @event_open)
    post_auth '/posts', { post: { body: 'Post Body', event_id: @event_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create an event post but fails, posts are disabled at UserRole level, fails because of app setting (76)" do
    create(:app_setting, app_setting_option_id: 76, user_role: @user.user_role)
    post_auth '/posts', { post: { body: 'Post Body', event_id: @event_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create a group post but fails, , fails because of app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)
    post_auth '/posts', { post: { body: 'Post Body', group_id: @group_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create a group post but fails, posts are disabled at Group level, fails because of app setting (73)" do
    create(:app_setting, app_setting_option_id: 75, group: @group_open)
    post_auth '/posts', { post: { body: 'Post Body', group_id: @group_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create a group post but fails, posts are disabled at UserRole level" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    post_auth '/posts', { post: { body: 'Post Body', group_id: @group_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create an event article but fails, articles are disabled at App level" do
    create(:app_setting, app_setting_option_id: 77)
    post_auth '/posts', { post: { title: 'Article', body: 'Post Body', event_id: @event_open.id } }
    response.status.should eq(403)
  end

  it "POST /posts; attempts to create an event article but fails articles are disabled at UserRole level" do
    create(:app_setting, app_setting_option_id: 78, user_role: @user.user_role)
    
    post_auth '/posts', { post: { title: 'Article', body: 'Post Body', event_id: @event_open.id } }
    
    response.status.should eq(403)
  end

  it "POST /posts; create an event post, passes empty title/excerpt, success even though articles are disabled at App level" do
    event_user = create(:event_user, event: @event_open, user: @user)

    create(:app_setting, app_setting_option_id: 77)
    
    post_auth '/posts', { post: { title: nil, excerpt: nil, body: 'Post Body', event_id: @event_open.id } }
    
    response.status.should eq(201)
  end

  it "POST /posts; create an event post, passes empty title/excerpt, success even though articles are disabled at UserRole level" do
    event_user = create(:event_user, event: @event_open, user: @user)
    create(:app_setting, app_setting_option_id: 78, user_role: @user.user_role)
    
    post_auth '/posts', { post: { title: nil, excerpt: nil, body: 'Post Body', event_id: @event_open.id } }
    
    response.status.should eq(201)
  end

  it "POST /posts; creates an event post, works even though articles are disabled at App level" do
    event_user = create(:event_user, event: @event_open, user: @user)    
    create(:app_setting, app_setting_option_id: 77)
    
    post_auth '/posts', { post: { body: 'Post Body', event_id: @event_open.id } }
    
    response.status.should eq(201)
  end

  it "POST /posts; creates an event post, works even though articles are disabled at UserRole level" do
    event_user = create(:event_user, event: @event_open, user: @user)
    create(:app_setting, app_setting_option_id: 78, user_role: @user.user_role)
    
    post_auth '/posts', { post: { body: 'Post Body', event_id: @event_open.id } }
    
    response.status.should eq(201)
  end
 
  it "PATCH /posts/:id; attempts to update post, fails because of app setting (83)" do
    create(:app_setting, app_setting_option_id: 83)
    post = create(:post, title: 'This is the old title', body: 'Body by Jake', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: 'New Title' } }

    response.status.should eq(403)
  end  

  xit "PATCH /posts/:id; attempts to update post, fails because of app setting (84)" do
    create(:app_setting, app_setting_option_id: 84, user_role: @user.user_role)
    post = create(:post, title: 'This is the old title', body: 'Body by Jake', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: 'New Title' } }

    response.status.should eq(403)
  end  

  xit "PATCH /posts/:id; attempts to update post, fails because of app setting (76)" do
    create(:app_setting, app_setting_option_id: 76, user_role: @user.user_role)
    post = create(:post, title: 'This is the old title', body: 'Body by Jake', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: 'New Title' } }

    response.status.should eq(403)
  end  

  it "PATCH /posts/:id; attempts to update post, fails because of app setting (73)" do
    create(:app_setting, app_setting_option_id: 73)
    post = create(:post, title: 'This is the old title', body: 'Body by Jake', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: 'New Title' } }

    response.status.should eq(403)
  end    

  xit "PATCH /posts/:id; attempts to update post, fails because of app setting (22)" do
    create(:app_setting, app_setting_option_id: 22, user_role: @user.user_role)
    post = create(:post, title: 'This is the old title', body: 'Body by Jake', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: 'New Title' } }

    response.status.should eq(403)
  end  

  it "PATCH /posts/:id; attempts to update post, fails because of app setting (21)" do
    create(:app_setting, app_setting_option_id: 21)
    post = create(:post, title: 'This is the old title', body: 'Body by Jake', event: @event_open, creator: @user)

    patch_auth "/posts/#{post.id}", { post: { title: 'New Title' } }

    response.status.should eq(403)
  end

  it "DELETE /posts/:id; attempts to delete post, fails because of app setting (90)" do
    create(:app_setting, app_setting_option_id: 90, user_role: @user.user_role)
    post = create(:post, event: @event_open, creator: @user)

    delete_auth "/posts/#{post.id}"

    response.status.should eq(403)
  end  

  it "DELETE /posts/:id; attempts to delete post, fails because of app setting (89)" do
    create(:app_setting, app_setting_option_id: 89)
    post = create(:post, event: @event_open, creator: @user)

    delete_auth "/posts/#{post.id}"

    response.status.should eq(403)
  end

  xit "GET /posts/:id; posts shouldn't display attachments - app setting (115)" do
    create(:app_setting, app_setting_option_id: 115, user_role: @user.user_role)
    attachment = create(:post_attachment, post: @post_group_open, url: "the shadow knows what evil")

    get_auth "/posts/#{@post_group_open.id}"

    json["post"]["post_attachments"].should eq nil
  end

end
