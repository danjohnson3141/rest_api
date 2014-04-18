module V1
  class EventSessionEvaluationsController < ApplicationController


    # GET /event_evaluations/:id
    def show
      permission_check
      render json: EventSessionEvaluation.find(params[:id])
    end

    private
      # Use callbacks to share common setup or constraints between actions.

      def permission_check
        raise ActiveRecord::RecordNotFound if !current_user.events_section?
        raise ApiAccessEvanta::PermissionDenied if !current_user.event_evaluations?
      end

  end
end
