class EventEvaluationSerializer < ActiveModel::Serializer
  attributes :id, :name, :survey_link, :display_rank
  has_one :event, serializer: EventTinySerializer
end
