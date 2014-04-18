class EventSessionEvaluationSerializer < ActiveModel::Serializer
  attributes :id, :name, :survey_link
  has_one :event, serializer: EventTinySerializer
  has_one :event_session, serializer: EventSessionShortSerializer
end
