class EventSessionSerializer < ActiveModel::Serializer

  attributes :id, :name, :description, :start_date_time, :end_date_time, :track_name, :breakout_group_member?,
  :session_type, :room_name, :is_comments_on, :comment_count, :show_my_schedule?, :show_event_notes?,
  :show_bookmarks?, :show_event_session_evaluations?, :can_like?, :session_comments?,
  :event_note_id, :event_bookmark_id, :event_schedule_id, :display_rank

  has_one :event, serializer: EventTinySerializer
  has_one :breakout_group, serializer: GroupTinySerializer
  has_one :sponsor, serializer: SponsorShortSerializer
  has_one :post, serializer: PostShortSerializer
  has_many :event_speakers, serializer: EventSpeakerShortSerializer
  has_many :event_session_evaluations, serializer: EventSessionEvaluationShortSerializer

  def event_session_evaluations
    object.get_event_session_evaluations(scope)
  end

  def name
    object.session_name
  end

  def description
    object.session_description
  end

  def show_my_schedule?
    object.show_my_schedule?(scope)
  end

  def show_event_notes?
    object.show_event_notes?(scope)
  end

  def show_bookmarks?
    object.show_bookmarks?(scope)
  end

  def show_event_session_evaluations?
    object.show_event_session_evaluations?(scope)
  end

  def breakout_group_member?
    object.breakout_group_member?(scope)
  end

  def can_like?
    scope.allowed_to?(action: :like, object: object.post)
  end

  def show_post_likes_list?
    object.post.show_post_likes_list?(scope)
  end

  def session_comments?
    object.session_comments?(scope)
  end

  def event_note_id
    object.note_for_user(scope).try(:id)
  end

  def event_bookmark_id
    object.bookmark_for_user(scope).try(:id)
  end

  def event_schedule_id
    object.schedule_for_user(scope).try(:id)
  end
end
