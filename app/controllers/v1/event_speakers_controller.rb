module V1
  class EventSpeakersController < ApplicationController

    # GET /event_speakers/:id
    def show
      @event_speaker = EventSpeaker.find(params[:id])
      event = @event_speaker.event_session.event
      raise ApiAccessEvanta::PermissionDenied if !event.show_speakers?(current_user)
      raise ApiAccessEvanta::PermissionDenied if event.group.private? && !current_user.event_user_or_group_member?(event)
      raise ActiveRecord::RecordNotFound if event.group.secret? && !current_user.event_user_or_group_member?(event)
      render json: @event_speaker, serailizer: EventSpeakerSerializer
    end

    # GET /event_speakers/event_session/:event_session_id
    def show_session_speakers
      event_session = EventSession.find(params[:event_session_id])
      raise ApiAccessEvanta::PermissionDenied if !event_session.event.show_speakers?(current_user)
      @event_speakers = event_session.speakers
      render json: @event_speakers, each_serailizer: EventSpeakerShortSerializer
    end

    # GET /event_speakers/event/:event_id
    def show_event_speakers
      event = Event.find(params[:event_id])
      raise ApiAccessEvanta::PermissionDenied if !event.show_speakers?(current_user)
      render json: event.event_speakers, each_serailizer: EventSpeakerShortSerializer
    end

  end
end
