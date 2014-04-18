class PostComment < ActiveRecord::Base
  include User::Associations
  include TimeAgo
  belongs_to :user
  belongs_to :post
  has_many :post_comment_attatchments
  validates :body, presence: true, length: { maximum: 2000 }
  validates :user_id, presence: true

  after_save :notify_author_and_followers


  def post_action_message
    "commented on this post"
  end
 
  def notify_author_and_followers
    if post.creator.notifications? && user != post.creator
      body = "#{user.full_name} commented on your post."
      Notification.create(body: body, notification_user: post.creator, post: post, user: user)
    end

    post.post_followers.each do |post_follower|
      if post_follower.user.notifications? && post_follower.user != post.creator
        body = "#{user.full_name} commented on a post you're following."
        Notification.create(body: body, notification_user: post_follower.user, post: post_follower.post, user: user)
      end
    end
  end
end
