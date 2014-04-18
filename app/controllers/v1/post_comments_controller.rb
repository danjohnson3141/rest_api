module V1
  class PostCommentsController < ApplicationController
    include ObjectSetters

    before_action only: [:show, :update, :destroy] { set_object(PostComment) }
    before_action :set_post, only: [:post_comments]

    # GET /post_comments/posts/:post_id
    def post_comments
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post)
      render json: @post.post_comments
    end

    # GET /post_comments/:id
    def show
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post_comment.post)
      render json: @post_comment
    end

    # POST /post_comments
    def create
      @post_comment = PostComment.new(post_params)
      raise ApiAccessEvanta::Unprocessable if @post_comment.post.nil?
      raise ApiAccessEvanta::RecordOutOfScope unless current_user.allowed_to?(action: :view, object: @post_comment.post)
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :create, object: @post_comment)

      if @post_comment.save
        render json: @post_comment, status: :created
      else
        render json: @post_comment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /post_comments/1
    def update
      raise ApiAccessEvanta::PermissionDenied unless current_user.post_comments?
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :update, object: @post_comment)

      if @post_comment.update(patch_params)
        head :no_content
      else
        render json: @post_comment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /post_comments/1
    def destroy
      raise ApiAccessEvanta::PermissionDenied unless current_user.post_comments?
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :destroy, object: @post_comment)
      @post_comment.destroy
      head :no_content
    end

    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def patch_params
        params.require(:post_comment).permit(:body).
        merge!({"updated_by" => current_user})
      end

      def post_params
        params.require(:post_comment).permit(:post_id, :body).
        merge!({"user_id" => current_user.id, "creator" => current_user, "updator" => current_user})
      end

      def set_post
        @post = Post.includes(post_comments: :user).find(params[:post_id])
      end
  end
end