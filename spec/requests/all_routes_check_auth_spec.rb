require 'spec_helper'

describe "AllRoutesCheckAuthentication" do

  after(:each) do
    response.status.should eq(201)
  end

  it "POST /app_supports; empty email address" do
    post '/app_supports', { app_support: { body: "text" } }
  end

end

describe "AllRoutesCheckAuthorization" do

  after(:each) do
    response.status.should eq(403)
  end

  it "PATCH /users/password; checks route for proper auth response" do
    patch "/users/password"
  end

  it "POST /users/password; checks route for proper auth response" do
    post "/users/password"
  end

  it "PUT /users/password; checks route for proper auth response" do
    put "/users/password"
  end

end

describe "AllRoutesCheckAuthentication" do

  after(:each) do
    response.status.should eq(401)
  end

  it "DELETE /event_bookmarks/:id; checks route for proper auth response" do
    delete "/event_bookmarks/1"
  end

  it "DELETE /event_followers/:id; checks route for proper auth response" do
    delete "/event_followers/1"
  end

  it "DELETE /event_notes/:id; checks route for proper auth response" do
    delete "/event_notes/1"
  end

  it "DELETE /event_user_schedules/:id; checks route for proper auth response" do
    delete "/event_user_schedules/1"
  end

  it "DELETE /event_users/:event_user_id; checks route for proper auth response" do
    delete "/event_users/1"
  end

  it "DELETE /group_invites/:id; checks route for proper auth response" do
    delete "/group_invites/1"
  end

  it "DELETE /group_members/:group_member_id; checks route for proper auth response" do
    delete "/group_members/1"
  end

  it "DELETE /group_requests/:id; checks route for proper auth response" do
    delete "/group_requests/1"
  end

  it "DELETE /messages/:message_id; checks route for proper auth response" do
    delete "/messages/1"
  end

  it "DELETE /messages/conversation/:user_id; checks route for proper auth response" do
    delete "/messages/conversation/1"
  end

  it "DELETE /post_comments/:id; checks route for proper auth response" do
    delete "/post_comments/1"
  end

  it "DELETE /post_likes/:id; checks route for proper auth response" do
    delete "/post_likes/1"
  end

  it "DELETE /posts/:id; checks route for proper auth response" do
    delete "/posts/1"
  end

  it "DELETE /user_connections/:id; checks route for proper auth response" do
    delete "/user_connections/1"
  end

  it "DELETE /users/sign_out; checks route for proper auth response" do
    delete "/users/sign_out"
  end

  it "GET /app/labels/:page; checks route for proper auth response" do
    app_label_dictionary = create(:app_label_dictionary, :auth_required)
    get "/app/labels/#{app_label_dictionary.app_label_page.name}"
  end

  it "GET /app_setting_options/:id; checks route for proper auth response" do
    get "/app_setting_options/1"
  end

  it "GET /event_bookmarks; checks route for proper auth response" do
    get "/event_bookmarks"
  end

  it "GET /event_bookmarks/:id; checks route for proper auth response" do
    get "/event_bookmarks/1"
  end

  it "GET /event_bookmarks/event/:event_id; checks route for proper auth response" do
    get "/event_bookmarks/event/1"
  end

  it "GET /event_evaluations/:id; checks route for proper auth response" do
    get "/event_evaluations/1"
  end

  # it "GET /featured_posts/event/event_id; checks route for proper auth response" do
  #   get "/featured_posts/event/1"
  # end

  # it "GET /featured_posts/group/group_id; checks route for proper auth response" do
  #   get "/featured_posts/group/1"
  # end

  # it "GET /event_followers/events/:user_id; checks route for proper auth response" do
  #   get "/event_followers/events/1"
  # end

  it "GET /event_followers/users/:event_id; checks route for proper auth response" do
    get "/event_followers/users/1"
  end

  it "GET /event_notes/:id; checks route for proper auth response" do
    get "/event_notes/1"
  end

  it "GET /event_notes/event/:event_id; checks route for proper auth response" do
    get "/event_notes/event/1"
  end

  it "GET /event_session_evaluations/:id; checks route for proper auth response" do
    get "/event_session_evaluations/1"
  end

  it "GET /event_sessions/:id; checks route for proper auth response" do
    get "/event_sessions/1"
  end

  it "GET /event_sessions/event/:event_id; checks route for proper auth response" do
    get "/event_sessions/event/1"
  end

  it "GET /event_sessions/my_schedule/:event_id; checks route for proper auth response" do
    get "/event_sessions/my_schedule/1"
  end

  it "GET /event_speakers/:id; checks route for proper auth response" do
    get "/event_speakers/1"
  end

  it "GET /event_speakers/event/:event_id; checks route for proper auth response" do
    get "/event_speakers/event/1"
  end

  it "GET /event_speakers/event_session/:event_session_id; checks route for proper auth response" do
    get "/event_speakers/event_session/1"
  end

  it "GET /event_users/attendees/:event_id; checks route for proper auth response" do
    get "/event_users/attendees/1"
  end

  it "GET /event_users/events/:user_id; checks route for proper auth response" do
    get "/event_users/events/1"
  end

  it "GET /event_users/users/:event_id; checks route for proper auth response" do
    get "/event_users/users/1"
  end

  it "GET /events/:id; checks route for proper auth response" do
    get "/events/1"
  end

  it "GET /events/all; checks route for proper auth response" do
    get "/events/all"
  end

  it "GET /events/past; checks route for proper auth response" do
    get "/events/past"
  end

  it "GET /events/upcoming; checks route for proper auth response" do
    get "/events/upcoming"
  end

  it "GET /group_invites/groups; checks route for proper auth response" do
    get "/group_invites/groups"
  end

  it "GET /group_invites/user_search/:group_id; checks route for proper auth response" do
    get "/group_invites/user_search/1"
  end

  it "GET /group_invites/users/:group_id; checks route for proper auth response" do
    get "/group_invites/users/1"
  end

  it "GET /group_members/groups/:user_id; checks route for proper auth response" do
    get "/group_members/groups/1"
  end

  it "GET /group_members/users/:group_id; checks route for proper auth response" do
    get "/group_members/users/1"
  end

  it "GET /group_requests/groups; checks route for proper auth response" do
    get "/group_requests/groups"
  end

  it "GET /group_requests/users/:group_id; checks route for proper auth response" do
    get "/group_requests/users/1"
  end

  it "GET /groups; checks route for proper auth response" do
    get "/groups"
  end

  it "GET /groups/:id; checks route for proper auth response" do
    get "/groups/1"
  end

  it "GET /messages; checks route for proper auth response" do
    get "/messages"
  end

  it "GET /messages/conversation/:user_id; checks route for proper auth response" do
    get "/messages/conversation/1"
  end

  it "GET /navigation/left; checks route for proper auth response" do
    get "/navigation/left"
  end

  it "GET /navigation/right/:event_id; checks route for proper auth response" do
    get "/navigation/right/1"
  end

  it "GET /notifications/:id; checks route for proper auth response" do
    get "/notifications/1"
  end

  it "GET /notifications/user/:user_id; checks route for proper auth response" do
    get "/notifications/user/1"
  end

  it "GET /options_test; checks route for proper auth response" do
    get "/options_test"
  end

  it "GET /post_comments/:id; checks route for proper auth response" do
    get "/post_comments/1"
  end

  it "GET /post_comments/post/:post_id; checks route for proper auth response" do
    get "/post_comments/post/1"
  end

  it "GET /post_likes/:id; checks route for proper auth response" do
    get "/post_likes/1"
  end

  it "GET /post_likes/posts/:user_id; checks route for proper auth response" do
    get "/post_likes/posts/1"
  end

  it "GET /post_likes/users/:post_id; checks route for proper auth response" do
    get "/post_likes/users/1"
  end

  it "GET /posts/:id; checks route for proper auth response" do
    get "/posts/1"
  end

  it "GET /posts/event/:event_id; checks route for proper auth response" do
    get "/posts/event/1"
  end

  it "GET /posts/group/:group_id; checks route for proper auth response" do
    get "/posts/group/1"
  end

  it "GET /posts/user/:user_id; checks route for proper auth response" do
    get "/posts/user/1"
  end

  it "GET /sponsors; checks route for proper auth response" do
    get "/sponsors"
  end

  it "GET /sponsors/:id; checks route for proper auth response" do
    get "/sponsors/1"
  end

  it "GET /sponsors/app; checks route for proper auth response" do
    get "/sponsors/app"
  end

  it "GET /sponsors/event; checks route for proper auth response" do
    get "/sponsors/event"
  end

  it "GET /sponsors/group; checks route for proper auth response" do
    get "/sponsors/group"
  end

  it "GET /user_connections/pending; checks route for proper auth response" do
    get "/user_connections/pending"
  end

  it "GET /users/connections/:user_id; checks route for proper auth response" do
    get "/users/connections/1"
  end

  it "GET /users/post_options; checks route for proper auth response" do
    get "/users/post_options"
  end

  it "GET /users/profile; checks route for proper auth response" do
    get "/users/profile"
  end

  it "GET /users/profile/:id; checks route for proper auth response" do
    get "/users/profile/1"
  end

  it "GET /users/sign_in; checks route for proper auth response" do
    get "/users/sign_in"
  end

  it "PATCH /event_notes/:id; checks route for proper auth response" do
    patch "/event_notes/1"
  end

  it "PATCH /group_requests/:id; checks route for proper auth response" do
    patch "/group_requests/1"
  end

  it "PATCH /groups/:id; checks route for proper auth response" do
    patch "/groups/1"
  end

  it "PATCH /post_comments/:id; checks route for proper auth response" do
    patch "/post_comments/1"
  end

  it "PATCH /posts/:id; checks route for proper auth response" do
    patch "/posts/1"
  end

  it "PATCH /user_connections/:id; checks route for proper auth response" do
    patch "/user_connections/1"
  end

  it "PATCH /users/profile; checks route for proper auth response" do
    patch "/users/profile"
  end

  it "POST /event_bookmarks; checks route for proper auth response" do
    post "/event_bookmarks"
  end

  it "POST /event_followers; checks route for proper auth response" do
    post "/event_followers"
  end

  it "POST /event_notes; checks route for proper auth response" do
    post "/event_notes"
  end

  it "POST /event_user_schedules; checks route for proper auth response" do
    post "/event_user_schedules"
  end

  it "POST /event_users; checks route for proper auth response" do
    post "/event_users"
  end

  it "POST /group_invites; checks route for proper auth response" do
    post "/group_invites"
  end

  it "POST /group_members; checks route for proper auth response" do
    post "/group_members"
  end

  it "POST /group_requests; checks route for proper auth response" do
    post "/group_requests"
  end

  it "POST /groups; checks route for proper auth response" do
    post "/groups"
  end

  it "POST /messages; checks route for proper auth response" do
    post "/messages"
  end

  it "POST /post_comments; checks route for proper auth response" do
    post "/post_comments"
  end

  it "POST /post_likes; checks route for proper auth response" do
    post "/post_likes"
  end

  it "POST /posts; checks route for proper auth response" do
    post "/posts"
  end

  it "POST /user_connections; checks route for proper auth response" do
    post "/user_connections"
  end

  it "POST /users/sign_in; checks route for proper auth response" do
    post "/users/sign_in"
  end

  it "PUT /event_notes/:id; checks route for proper auth response" do
    put "/event_notes/1"
  end

  it "PUT /group_requests/:id; checks route for proper auth response" do
    put "/group_requests/1"
  end

  it "PUT /groups/:id; checks route for proper auth response" do
    put "/groups/1"
  end

  it "PUT /post_comments/:id; checks route for proper auth response" do
    put "/post_comments/1"
  end

  it "PUT /posts/:id; checks route for proper auth response" do
    put "/posts/1"
  end

  it "PUT /user_connections/:id; checks route for proper auth response" do
    put "/user_connections/1"
  end

end