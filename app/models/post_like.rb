class PostLike < ActiveRecord::Base
  include User::Associations
  include TimeAgo

  belongs_to :user
  belongs_to :post

  validates :user_id, presence: true
  validates :post_id, presence: true
  validates :post_id, uniqueness: { scope: :user_id}

  after_save :notify_author
  
  default_scope { order('created_at DESC') }

  def notify_author
    return if !post.creator.notifications? || user == post.creator
    body = "#{user.full_name} liked your post."
    Notification.create(body: body, notification_user: post.creator, post: post, user: user)
  end

  def post_action_message
    "liked this post"
  end

end
