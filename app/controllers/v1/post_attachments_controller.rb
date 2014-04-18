module V1
  class PostAttachmentsController < ApplicationController

    include ObjectSetters

    before_action only: [:update, :destroy] { set_object(PostAttachment) }
 
    # POST /post_attachments
    def create
      @post_attachment = PostAttachment.new(post_params)

      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :create, object: @post_attachment)
      if @post_attachment.save
        render json: @post_attachment, status: :created
      else
        render json: @post_attachment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /post_attachments/1
    def update
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :update, object: @post_attachment)
      if @post_attachment.update(patch_params)
        head :no_content
      else
        render json: @post_attachment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /post_attachments/1
    def destroy
      raise ApiAccessEvanta::PermissionDenied unless current_user.allowed_to?(action: :destroy, object: @post_attachment)
      @post_attachment.destroy

      head :no_content
    end

    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def post_params
        params.require(:post_attachment).permit(:post_id, :url).merge!({"created_by" => current_user.id, "updated_by" => current_user.id})
      end
      def patch_params
        params.require(:post_attachment).permit(:url).merge!({"updated_by" => current_user.id})
      end
  end
end