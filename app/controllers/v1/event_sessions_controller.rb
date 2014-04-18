module V1
  class EventSessionsController < ApplicationController

    # GET /event_sessions/:event_session_id
    def show
      event_session = EventSession.find(params[:id])
      raise ApiAccessEvanta::PermissionDenied if !event_session.event.show_sessions?(current_user)
      render json: event_session
    end

    # GET /event_sessions/event/:event_id
    def event
      event = Event.find(params[:event_id])
      raise ApiAccessEvanta::PermissionDenied if !event.show_sessions?(current_user)
      render json: event.event_sessions
    end

    # GET /event_sessions/my_schedule/:event_id
    def my_schedule
      event = Event.find(params[:event_id])
      raise ApiAccessEvanta::PermissionDenied if !event.show_sessions?(current_user)
      @event_sessions = current_user.my_schedule(event: event)
      raise ActiveRecord::RecordNotFound if !@event_sessions
      render json: @event_sessions
    end

  end
end
