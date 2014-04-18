module V1
  class EventUserSchedulesController < ApplicationController
 
    before_action :set_event_session, only: [:create]


    # POST /event_user_schedules
    def create
      @event_user_schedule = current_user.add_session_to_my_schedule(@event_session)
      if @event_user_schedule.save
        render json: @event_user_schedule, serializer: EventUserScheduleShortSerializer, root: "event_user_schedule", status: :created
      else
        render json: @event_user_schedule.errors, status: :unprocessable_entity
      end

    end

    # DELETE /event_user_schedules/:id
    def destroy
      @event_user_schedule = EventUserSchedule.find(params[:id])
      if @event_user_schedule.event_user.user == current_user
        @event_user_schedule.destroy
        head :no_content
      else
        head :forbidden
      end
    end

    private
      # Never trust parameters from the scary internet, only allow the white list through.
      def event_user_schedule_params
        params.require(:event_user_schedule).permit(:event_session_id)
      end

      def set_event_session
        @event_session = EventSession.find(event_user_schedule_params[:event_session_id])
      end
  end
end