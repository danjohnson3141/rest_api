module V1
  class PostFollowersController < ApplicationController

    before_action :set_post_follower, only: [:destroy]

    # GET /post_followers/posts/:user_id
    def posts
      User.find(params[:user_id])
      @post_followers = PostFollower.where(user_id: params[:user_id])
      render json: @post_followers, each_serializer: PostFollowerUserSerializer
    end

    # GET /post_followers/users/:post_id
    def users
      Post.find(params[:post_id])
      @post_followers = PostFollower.where(post_id: params[:post_id])
      render json: @post_followers, each_serializer: PostFollowerPostSerializer
    end

    # POST /post_followers
    def create
      @post_follower = PostFollower.new(post_follower_params)

      if @post_follower.save
        render json: @post_follower, status: :created
      else
        render json: @post_follower.errors, status: :unprocessable_entity
      end
    end

    # DELETE /post_followers/:id
    def destroy
      if current_user.allowed_to?(action: :destroy, object: @post_follower)
        @post_follower.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def post_follower_params
        params.require(:post_follower).permit(:post_id).merge!({"user_id" => current_user.id, "created_by" => current_user.id, "updated_by" => current_user.id})
      end
      
      # Use callbacks to share common setup or constraints between actions.
      def set_post_follower
        @post_follower = PostFollower.find(params[:id])
      end
  end
end