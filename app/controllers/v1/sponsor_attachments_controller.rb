module V1
  class SponsorAttachmentsController < ApplicationController
    # GET /sponsor_attachments
    def index
      @sponsor_attachments = SponsorAttachment.all

      render json: @sponsor_attachments
    end

    # GET /sponsor_attachments/1
    def show
      @sponsor_attachment = SponsorAttachment.find(params[:id])

      render json: @sponsor_attachment
    end

    # POST /sponsor_attachments
    def create
      @sponsor_attachment = SponsorAttachment.new(params[:sponsor_attachment])

      if @sponsor_attachment.save
        render json: @sponsor_attachment, status: :created, location: @sponsor_attachment
      else
        render json: @sponsor_attachment.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /sponsor_attachments/1
    def update
      @sponsor_attachment = SponsorAttachment.find(params[:id])

      if @sponsor_attachment.update(params[:sponsor_attachment])
        head :no_content
      else
        render json: @sponsor_attachment.errors, status: :unprocessable_entity
      end
    end

    # DELETE /sponsor_attachments/1
    def destroy
      @sponsor_attachment = SponsorAttachment.find(params[:id])
      @sponsor_attachment.destroy

      head :no_content
    end
  end
end