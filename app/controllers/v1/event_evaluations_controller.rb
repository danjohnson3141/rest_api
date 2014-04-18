module V1
  class EventEvaluationsController < ApplicationController


    # GET /event_evaluations/:id
    def show
      @event_evaluation = EventEvaluation.find(params[:id])
      permission_check
      render json: @event_evaluation
    end

    # GET /event_evaluations/event/:event_id
    # def event_evaluations
    #   permission_check
    #   event = Event.find(params[:event_id])
    #   render json: current_user.event_evaluations(event)
    # end

    private
      # Use callbacks to share common setup or constraints between actions.

      def permission_check
        raise ActiveRecord::RecordNotFound if !current_user.events_section?
        raise ApiAccessEvanta::PermissionDenied if !current_user.event_evaluations? || current_user.user_role != @event_evaluation.user_role
      end

  end
end
