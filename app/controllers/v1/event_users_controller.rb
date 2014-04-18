module V1
  class EventUsersController < ApplicationController

    before_action :set_event_user, only: [:destroy]

    # GET /event_users/:id
    def show
      @event_user = EventUser.find(params[:id])

      render json: @event_user, serializer: EventUserWithNotesSerializer, root: 'event_user'
    end

    # POST /event_users
    def create
      @event_user = EventUser.new(event_user_params)

      if @event_user.save
        render json: @event_user, status: :created
      else
        render json: @event_user.errors, status: :unprocessable_entity
      end
    end

    # DELETE /event_users/:event_user_id
    def destroy
      if current_user.allowed_to?(action: :destroy, object: @event_user)
        @event_user.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    # GET /event_users/event/:user_id
    def events
      User.find(params[:user_id])
      @event_users = EventUser.where(user_id: params[:user_id])
      render json: @event_users, each_serializer: EventUserEventSerializer
    end

    # GET /event_users/attendees/:event_id
    def attendees
      @event = Event.find(params[:event_id])
      if @event.show_attendees?(current_user)
        render json: @event.attendees_excluding_hidden, each_serializer: EventUserAttendeeSerializer
      else
        head :forbidden
      end
    end

    # GET /event_users/users/:event_id
    def users
      Event.find(params[:event_id])
      @event_users = EventUser.where(event_id: params[:event_id]).joins(:event).includes(:event_registration_status)
      render json: @event_users, each_serializer: EventUserUserSerializer
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_event_user
        @event_user = EventUser.find(params[:event_user_id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def event_user_params
        params.require(:event_user).permit(:event_id, :event_registration_status_id).
        merge!({"user_id" => current_user.id, "created_by" => current_user.id, "updated_by" => current_user.id})
      end

  end
end
