module V1
  class PostLikesController < ApplicationController
    include ObjectSetters

    before_action only: [:show, :destroy] { set_object(PostLike) }
    before_action only: [:user_likes] { set_object(User) }
    before_action only: [:post_likes] { set_object(Post) }

    # GET post_likes/posts/:user_id
    def user_likes
      raise ApiAccessEvanta::PermissionDenied unless current_user.like_posts?
      raise ApiAccessEvanta::PermissionDenied unless current_user.view_profiles?
      raise ApiAccessEvanta::PermissionDenied unless @user.show_likes_count?

      if current_user == @user
        @post_likes = @user.post_likes_sorted_by_activity
      else
        @post_likes = @user.viewable_posts_likes_sorted_by_activity(current_user)
      end

      render json: @post_likes, each_serializer: PostLikePostSerializer
    end

    # GET post_likes/users/:post_id
    def post_likes
      raise ApiAccessEvanta::PermissionDenied unless current_user.like_posts?
      raise ApiAccessEvanta::PermissionDenied unless current_user.can_view_post_likes_list?
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post)
      render json: @post.post_likes.includes(:user), each_serializer: PostLikeUserSerializer
    end

    # GET /post_likes/:id
    def show
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post_like.post)
      render json: @post_like
    end

    # POST /post_likes
    def create
      @post_like = PostLike.new(post_params)
      raise ApiAccessEvanta::Unprocessable if @post_like.post.nil?
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post_like.post)
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :create, object: @post_like)

      if @post_like.save
        render json: @post_like, status: :created
      else
        render json: @post_like.errors, status: :unprocessable_entity
      end
    end

    # DELETE /post_likes/:id
    def destroy
      raise ApiAccessEvanta::PermissionDenied unless current_user.like_posts?
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :destroy, object: @post_like)

      @post_like.destroy
      head :no_content
    end

    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def post_params
        params.require(:post_like).permit(:post_id).
        merge!({"user_id" => current_user.id, "created_by" => current_user.id, "updated_by" => current_user.id})
      end
  end
end
