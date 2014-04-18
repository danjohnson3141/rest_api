class EventSpeakerShortSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :first_name, :last_name, :title, :organization_name, :bio, :speaker_type, :photo, :event_session_id

  def photo
    object.user.photo
  end
end
