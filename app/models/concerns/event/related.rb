module Event::Related
  extend ActiveSupport::Concern

  included do 
    belongs_to :event_user
    belongs_to :event_speaker
    belongs_to :event_session
    belongs_to :sponsor
  end

  def event
    return event_user.try(:event) if !event_user_id.nil? 
    return sponsor.try(:event) if !sponsor_id.nil?
    return event_session.try(:event) if !event_session_id.nil?
    return event_speaker.try(:event) if !event_speaker_id.nil?
  end


end