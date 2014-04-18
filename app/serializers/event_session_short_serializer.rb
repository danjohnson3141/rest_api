class EventSessionShortSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :start_date_time, :end_date_time, :track_name, :breakout_group_id,
  :session_type, :room_name, :is_comments_on, :display_rank

  def name
    object.session_name
  end

  def description
    object.session_description
  end
end
