require "spec_helper"

describe V1::FeaturedPostsController do
  describe "routing" do

    it "routes to #group" do
      expect(:get => "/featured_posts/group/1").to route_to("v1/featured_posts#group", group_id: '1')
    end

    it "routes to #event" do
      expect(:get => "/featured_posts/event/1").to route_to("v1/featured_posts#event", event_id: '1')
    end

    it "routes to #user" do
      expect(:get => "/featured_posts/user").to route_to("v1/featured_posts#user")
    end

  end
end
