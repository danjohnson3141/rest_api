class RecentActivitySerializer < ActiveModel::Serializer
  attributes :post_comment_id, :post_like_id, :post_attachment_id, :user_id, :message, :ago

  def post_comment_id
    if object.class == PostComment
      return object.id
    end
  end

  def post_like_id
    if object.class == PostLike
      return object.id
    end
  end

  def post_attachment_id
    if object.class == PostAttachment
      return object.id
    end
  end

  def user_id
    return object.post.creator.id if object.class == PostAttachment
    object.user_id
  end

  def message
    return "#{object.post.creator.full_name} #{object.post_action_message}" if object.class == PostAttachment
    "#{object.user.full_name} #{object.post_action_message}"
  end


end