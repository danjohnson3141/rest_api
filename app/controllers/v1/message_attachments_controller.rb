module V1
  class MessageAttachmentsController < ApplicationController
    # GET /message_attachments
    def index
      @message_attachments = MessageAttachment.all

      render json: @message_attachments
    end

    # GET /message_attachments/1
    def show
      @message_attachment = MessageAttachment.find(params[:id])

      render json: @message_attachment
    end

    # POST /message_attachments
    def create
      @message_attachment = MessageAttachment.new(params[:message_attachment])

      if @message_attachment.save
        render json: @message_attachment, status: :created, location: @message_attachment
      else
        render json: @message_attachment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /message_attachments/1
    def update
      @message_attachment = MessageAttachment.find(params[:id])

      if @message_attachment.update(params[:message_attachment])
        head :no_content
      else
        render json: @message_attachment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /message_attachments/1
    def destroy
      @message_attachment = MessageAttachment.find(params[:id])
      @message_attachment.destroy

      head :no_content
    end
  end
end