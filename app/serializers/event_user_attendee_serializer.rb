class EventUserAttendeeSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :event_note_id, :event_bookmark_id
  has_one :user, serializer: UserShortSerializer
  has_one :event_registration_status

  def event_note_id
    object.note_for_user(scope).try(:id)
  end

  def event_bookmark_id
    object.bookmark_for_user(scope).try(:id)
  end

end
