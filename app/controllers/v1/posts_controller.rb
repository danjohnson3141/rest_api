module V1
  class PostsController < ApplicationController
    include ObjectSetters

    before_action :set_post, only: [:show, :update, :destroy]
    before_action only: [:user_posts] { set_object(User) }
    before_action only: [:event_posts] { set_object(Event) }
    before_action only: [:group_posts] { set_object(Group) }

    # GET /posts/:id
    def show
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post)
      @post.increase_view_count
      render json: @post
    end

    # GET /posts/event/:event_id
    def event_posts
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @event)
      render json: @event.feed, each_serializer: PostFeedSerializer
    end

    # GET /posts/group/:group_id
    def group_posts
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view_secret, object: @group)
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :view, object: @group)
      render json: Query::GroupActivityFeed.new(@group).query, each_serializer: PostFeedSerializer
    end

    # GET /posts/user/:user_id
    def user_posts
      raise ApiAccessEvanta::PermissionDenied if !current_user.view_profiles?
      raise ApiAccessEvanta::PermissionDenied if !@user.show_posts_count?

      if current_user == @user
        @posts = @user.posts_sorted_by_activity
      else
        @posts = @user.viewable_posts_sorted_by_activity(current_user)
      end
      render json: @posts, each_serializer: PostFeedSerializer
    end

    # POST /posts
    def create
      set_associated_post_objects
      @post = Post.new(post_params)
      post_permission_check
      if @post.save
        render json: @post, each_serializer: PostShortSerializer, status: :created
      else
        render json: @post.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /posts/:id
    def update
      if @post.creator?(current_user) && @post.allow_edits?
        if @post.update(patch_params)
          head :no_content
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      else
        head status: :forbidden
      end
    end

    # DELETE /posts/:id
    def destroy
      raise ApiAccessEvanta::PermissionDenied if !current_user.allowed_to?(action: :destroy, object: @post)
      @post.destroy
      head :no_content
    end

   private
      # Never trust parameters from the scary internet, only allow the white list through.
      def post_params
        filtered_params = params.require(:post).permit(:title, :body, :body_markdown, :excerpt, :thumbnail_teaser_photo, :event_id, :group_id).
        merge!({"created_by" => current_user.id, "updated_by" => current_user.id})
        translate_event(filtered_params)
      end

      def translate_event(filtered_params)
        if filtered_params.has_key? :event_id
          filtered_params[:event] = Event.find(filtered_params[:event_id])
          filtered_params.except!(:event_id)
        end
        filtered_params
      end

      def patch_params
        params.require(:post).permit(:title, :body, :body_markdown, :excerpt, :thumbnail_teaser_photo).
        merge!({"updated_by" => current_user.id})
      end

      def set_post
        @post = Post.includes(post_comments: :user).find(params[:id])
      end

      def set_associated_post_objects
        raise ApiAccessEvanta::Unprocessable if post_params[:event].present? && post_params[:group_id].present?
        raise ApiAccessEvanta::Unprocessable if post_params[:event].nil? && post_params[:group_id].nil?
        @object = Event.find(post_params[:event]) if post_params[:event].present?
        @object = Group.find(post_params[:group_id]) if post_params[:group_id].present?
      end

      def post_permission_check
        raise ApiAccessEvanta::PermissionDenied if !@object.allow_post_creation?(current_user)
        if params[:post][:title].present? || params[:post][:excerpt].present?
          raise ApiAccessEvanta::PermissionDenied if !current_user.create_articles?
        end
      end

  end
end
