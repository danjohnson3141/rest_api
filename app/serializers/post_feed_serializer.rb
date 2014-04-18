class PostFeedSerializer < ActiveModel::Serializer
  attributes :id, :title, :excerpt, :generated_excerpt, :thumbnail_teaser_photo, :view_count, :show_likes_count?, :like_count, :comment_count, :post_like_id, 
  :can_like?, :featured?, :show_post_likes_list?, :ago
  has_one :group, serializer: GroupTinySerializer
  has_one :event, serializer: EventTinySerializer
  has_one :sponsor, serializer: SponsorShortSerializer
  has_one :event_session, serializer: EventSessionMicroSerializer
  has_one :recent_activity, serializer: RecentActivitySerializer
  has_many :authors, serializer: UserTinySerializer
  has_many :post_attachments

  def post_like_id
    PostLike.where(user: scope, post: object).order("created_at DESC").first.try(:id)
  end

  def show_likes_count?
    object.show_likes_count?(scope)
  end

  def can_like?
    scope.allowed_to?(action: :like, object: object)
  end

  def post_comments?
    object.post_comments?(scope)
  end

  def show_post_likes_list?
    object.show_post_likes_list?(scope)
  end

end
