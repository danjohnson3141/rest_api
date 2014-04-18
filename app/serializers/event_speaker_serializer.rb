class EventSpeakerSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :title, :organization_name, :bio, :speaker_type, :moderator, :photo, :user_id, :event_note_id, :event_bookmark_id
  has_one :user, serializer: UserShortSerializer
  has_many :event_sessions, serializer: EventSessionShortSerializer
  has_one :event, serializer: EventTinySerializer

  def photo
    object.user.photo
  end

  def event_note_id
    object.note_for_user(scope).try(:id)
  end

  def event_bookmark_id
    object.bookmark_for_user(scope).try(:id)
  end

  def event_sessions
    object.get_event_sessions(user: scope, event: object.event)
  end

end
