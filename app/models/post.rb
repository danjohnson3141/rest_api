class Post < ActiveRecord::Base
  include User::Associations
  include TimeAgo

  belongs_to :group
  belongs_to :event
  belongs_to :event_session
  belongs_to :user
  belongs_to :sponsor
  has_one :featured_post, dependent: :destroy
  has_many :notifications, dependent: :delete_all
  has_many :post_likes, dependent: :delete_all
  has_many :post_followers, dependent: :delete_all
  has_many :post_comments, dependent: :delete_all
  has_many :post_attachments, dependent: :delete_all
  has_many :post_contributors, dependent: :delete_all
  has_many :post_contributor_users, through: :post_contributors, source: :user

  validates :title, length: { maximum: 255 }
  validates :body, presence: true
  validates :creator, presence: true
  validates :event_session_id, uniqueness: true, allow_nil: true
  validate :post_validation

  default_scope { order("created_at DESC") }

  def associated_group

  end

  def get_event
    return event if event.present?
    return event_session.event if event_session.present?
    nil
  end

  def generated_excerpt
    return body[0,200] if excerpt.nil?
    self.excerpt
  end

  # For session posts override author to session speaker
  def authors
    return self.event_session.event_speakers if self.event_session.present?
    return [creator] unless self.post_contributors.present?
    return self.post_contributor_users
  end

  def recent_activity
    like = most_recent_like
    comment = most_recent_comment
    attachment = most_recent_attachment
    return nil if like.id.nil? && comment.id.nil? && attachment.id.nil?
    [like, comment, attachment].max_by {|x| x.created_at }
  end

  def most_recent_like
    like = self.post_likes.max_by {|x| x.created_at }
    like ||= PostLike.new(created_at: Date.new)
    like
  end

  def most_recent_comment
    comment = self.post_comments.max_by {|x| x.created_at }
    comment ||= PostComment.new(created_at: Date.new)
    comment
  end

  def most_recent_attachment
    attachment = self.post_attachments.max_by {|x| x.created_at }
    attachment ||= PostAttachment.new(created_at: Date.new)
    attachment
  end

  def featured?
    self.featured_post.present?
  end

  def creator?(user)
    self.creator == user
  end

  def like_count
    self.post_likes.count
  end

  def comment_count
    self.post_comments.count
  end

  def show_likes_count?(user)
    AppSettings::Value.new(:show_likes_count, user: user).on?
  end

  def show_post_likes_list?(user)
    AppSettings::Value.new(:show_post_likes_list, user: user).on?
  end

  def allow_edits?
    AppSettings::Value.new(:post_edits).on?
  end

  def increase_view_count
    new_view_count = (self.view_count || 0) + 1
    self.update_attribute(:view_count, new_view_count)
  end

  private

    def post_validation
      count = 0
      count += 1 if group_id.present?
      count += 1 if event_id.present?
      count += 1 if event_session_id.present?
      errors.add(:post, "must have 1 and only 1: group_id, event_id, event_session_id") if count != 1 
    end

end