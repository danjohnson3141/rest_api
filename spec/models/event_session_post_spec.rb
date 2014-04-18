# require 'spec_helper'

# describe EventSessionPost do
#   it "creating a session will create and event_session_post w/ event & event_session" do
#     event = create(:event, :random)
#     event_session = create(:event_session, :random, event: event)
#     event_session_post = EventSessionPost.first
#     event_session_post.event_session.should eq event_session
#     event_session_post.event.should eq event_session.event
#   end

#   it "creating an event post will create and event_session_post w/ event & post" do
#     event = create(:event, :random)
#     post = create(:post, :random, event: event)
#     event_session_post = EventSessionPost.first
#     event_session_post.post.should eq post
#     event_session_post.event.should eq post.event
#   end

#   it "creating an event session post will create and event_session_post w/ event, post, & event_session" do    
#     event = create(:event, :random)
#     # event2 = create(:event, :random)
#     post = create(:post, :random, event: event)
#     event_session = EventSession.create(event: event)
#     esp = EventSessionPost.where(post_id: post.id, event: event).first
#     esp.event_session = event_session
#     # event_session.post = post
#     # binding.pry
#     # event_session = create(:event_session, :random, event: event)
#     # event_session.update_attribute(:post, post)
#     EventSessionPost.count.should eq 1
#     event_session_post = EventSessionPost.first
#     event_session_post.post.should eq post
#     event_session_post.event.should eq post.event
#     event_session_post.event.should eq event_session.event
#     event_session_post.event_session.should eq event_session
#   end

#   it "Requires event or post" do
#     event = create(:event, :random)
#     esp = EventSessionPost.create(event: event)
#     esp.errors.messages[:event_session_post].should eq ["Please provide at least one of the following: event_session_id, post_id."]
#   end

# end
