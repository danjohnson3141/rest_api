module V1
  class FeaturedPostsController < ApplicationController
    include ObjectSetters

    before_action only: [:event] { set_object(Event) }
    before_action only: [:group] { set_object(Group) }
    
    # GET /featured_posts/event/:event_id
    def event
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @event)
      render json: @event.featured_posts.limit(params[:limit])
    end

    # GET /featured_posts/group/:group_id
    def group
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view_secret, object: @group)
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: @group)
      render json: @group.featured_posts.limit(params[:limit])
    end

    # GET /featured_posts/user
    def user
      @featured_posts = FeaturedPost.all

      render json: @featured_posts
    end

   end
end