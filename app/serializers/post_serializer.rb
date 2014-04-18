class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :excerpt, :generated_excerpt, :body, :body_markdown, :thumbnail_teaser_photo, :display_rank, :view_count, :like_count, :can_like?, :comment_count, :can_comment?, :can_delete?, :post_like_id, :ago, :event_session_id
  has_one :group, serializer: GroupTinySerializer
  has_one :event, serializer: EventTinySerializer
  has_one :sponsor, serializer: SponsorShortSerializer
  has_many :authors, serializer: UserTinySerializer
  has_many :post_attachments, serializer: PostAttachmentSerializer
  has_many :post_comments, serializer: PostCommentShortSerializer

  def post_like_id
    PostLike.where(user: scope, post: object).first.try(:id)
  end

  def can_like?
    scope.allowed_to?(action: :like, object: object)
  end

  def can_comment?
    scope.allowed_to?(action: :comment, object: object)
  end

  def can_delete?
    scope.allowed_to?(action: :destroy, object: object)
  end

  def like_count
    return false if AppSettings::Value.new(:show_post_likes_list, user: scope).off?
    object.like_count
  end

end
