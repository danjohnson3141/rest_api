module V1
  class EventBookmarksController < ApplicationController

    before_action :set_event_bookmark, only: [:show, :destroy]

    # GET /event_bookmarks
    def index
      @event_bookmarks = EventBookmark.all

      render json: @event_bookmarks, each_serializer: EventBookmarkShortSerializer
    end

    def event_index
      event = Event.find(params[:event_id])
      raise ApiAccessEvanta::PermissionDenied if !event.allow_bookmarks?(current_user)
      @event_bookmarks = event.bookmarks(current_user)
      render json: @event_bookmarks, each_serializer: EventBookmarkShortSerializer
    end

    # GET /event_bookmarks/1
    def show
      render json: @event_bookmark, serializer: EventBookmarkShortSerializer, root: "event_bookmark"
    end

    # POST /event_bookmarks
    def create
      @event_bookmark = EventBookmark.new(post_params)
      event = @event_bookmark.event

      raise ApiAccessEvanta::Unprocessable if event.nil?
      raise ApiAccessEvanta::PermissionDenied if !event.allow_bookmarks?(current_user)

      if @event_bookmark.save
        render json: @event_bookmark, serializer: EventBookmarkShortSerializer, root: "event_bookmark", status: :created
      else
        render json: @event_bookmark.errors, status: :unprocessable_entity
      end
    end

    # DELETE /event_bookmarks/1
    def destroy
      if current_user.allowed_to?(action: :destroy, object: @event_bookmark)
        @event_bookmark.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event_bookmark
        @event_bookmark = EventBookmark.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def post_params
        params.require(:event_bookmark).permit(:event_user_id, :sponsor_id, :event_speaker_id, :event_session_id).
        merge!({"created_by" => current_user.id, "updated_by" => current_user.id})
      end

  end
end
