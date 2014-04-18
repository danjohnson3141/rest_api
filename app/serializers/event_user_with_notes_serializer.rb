class EventUserWithNotesSerializer < ActiveModel::Serializer
  attributes :id, :event_note_id, :event_bookmark_id
  has_one :user, serializer: UserNanoSerializer
  has_one :event, serializer: EventTinySerializer

  def event_note_id
    return EventNote.where(event_user: object, creator: scope).first.id if EventNote.where(event_user: object, creator: scope).first.present?
    nil
  end
  def event_bookmark_id
    return EventBookmark.where(event_user: object, creator: scope).first.id if EventBookmark.where(event_user: object, creator: scope).first.present?
    nil
  end
end
