module V1
  class EventNotesController < ApplicationController

    before_action :set_event_note, only: [:show, :update, :destroy]

    # GET /event_notes
    def index
      @event_notes = EventNote.all

      render json: @event_notes
    end

    # GET /event_notes/event/:event_id
    def event_index
      event = Event.find(params[:event_id])
      raise ApiAccessEvanta::PermissionDenied if !event.allow_notes?(current_user)
      @event_notes = event.notes(current_user)
      render json: @event_notes, each_serializer: EventNoteShortSerializer
    end

    # GET /event_notes/1
    def show
      @event_note = EventNote.find(params[:id])

      render json: @event_note, serializer: EventNoteShortSerializer, root: "event_note"
    end

    # POST /event_notes
    def create
      @event_note = EventNote.new(post_params)
      event = @event_note.event
      raise ApiAccessEvanta::Unprocessable if event.nil?
      raise ApiAccessEvanta::PermissionDenied if !event.allow_notes?(current_user)

      if @event_note.save
        render json: @event_note, serializer: EventNoteShortSerializer, root: "event_note", status: :created
      else
        render json: @event_note.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /event_notes/1
    def update
      if current_user.allowed_to?(action: :update, object: @event_note)
        if @event_note.update(patch_params)
          head :no_content
        else
          render json: @event_note.errors, status: :unprocessable_entity
        end
      else
        head :forbidden
      end
    end

    # DELETE /event_notes/1
    def destroy
      if current_user.allowed_to?(action: :destroy, object: @event_note)
        @event_note.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event_note
        @event_note = EventNote.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def post_params
        params.require(:event_note).permit(:body, :event_user_id, :sponsor_id, :event_speaker_id, :event_session_id).
        merge!({"created_by" => current_user.id, "updated_by" => current_user.id})
      end

      def patch_params
        params.require(:event_note).permit(:body).
        merge!({"created_by" => current_user.id, "updated_by" => current_user.id})
      end

  end
end
