class EventSpeaker < ActiveRecord::Base
  include User::Associations
  belongs_to :user
  belongs_to :event_session
  has_one :event, through: :event_session

  validates :event_session_id, presence: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :user_id, presence: true, uniqueness: { scope: :event_session_id }

  def note_for_user(user)
    EventNote.where(event_speaker_id: self.id).where(created_by: user.id).first
  end

  def bookmark_for_user(user)
    EventBookmark.where(event_speaker_id: self.id).where(created_by: user.id).first
  end

  def photo
    user.photo
  end

  def get_event_sessions(user: user, event: event)
    user_groups = user.group_memberships.map(&:id)
    event_user = user.event_user(self.event).present?
    self.user.event_speakers.includes([:event_session, :event]).
    joins(:event).
    where("(events.group_id in (?) or true = #{event_user}) and events.id = ?", user_groups, event.id).
    order("event_sessions.start_date_time, event_sessions.display_rank, event_sessions.name").map(&:event_session)
  end

end
