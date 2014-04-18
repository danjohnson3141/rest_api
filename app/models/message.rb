class Message < ActiveRecord::Base
  include User::Associations
  include TimeAgo

  belongs_to :sender_user, class_name: 'User', foreign_key: 'sender_user_id'
  belongs_to :recipient_user, class_name: 'User', foreign_key: 'recipient_user_id'

  validates :sender_user_id, presence: true
  validates :recipient_user_id, presence: true
  validates :body, presence: true, length: { maximum: 6000 }

  before_save :check_permission

  def self.get_message_list(user)
    messages = []
    Message.where('(sender_user_id = ? AND sender_deleted = 0) OR (recipient_user_id = ? AND recipient_deleted = 0)', user.id, user.id).group("sender_user_id, recipient_user_id").each do|message|
      messages << get_most_recent_message(message.sender_user_id, message.recipient_user_id)
    end
    Message.where(id: messages.map(&:id).uniq).order(created_at: :desc)
  end

  def self.get_most_recent_message(user_one_id, user_two_id)
    Message.where('(sender_user_id = ? AND recipient_user_id = ?) OR (recipient_user_id = ? AND sender_user_id = ?)', user_one_id, user_two_id, user_one_id, user_two_id).
    order(created_at: :desc).
    includes([:sender_user, :recipient_user]).first
  end

  def self.get_conversation(current_user, other_user_id)
    other_user = User.find(other_user_id)
    messages = Message.where('(sender_user_id = ? AND recipient_user_id = ?) OR (recipient_user_id = ? AND sender_user_id = ?) AND viewed_date IS NULL', current_user.id, other_user.id, current_user.id, other_user.id)
    messages.each do |message|
      message.mark_as_viewed(current_user.id)
    end

    # Get the fresh list of messages
    Message.where('((sender_user_id = ? AND sender_deleted != 1 ) AND recipient_user_id = ?) OR ((recipient_user_id = ? AND recipient_deleted != 1 ) AND sender_user_id = ?)', current_user.id, other_user.id, current_user.id, other_user.id).
    order(created_at: :desc).
    includes([:sender_user, :recipient_user])
  end

  # Marks the message as viewed once it is retrieved by the user
  def mark_as_viewed(recipient_user_id)
    if self.recipient_user_id == recipient_user_id && self.viewed_date.nil?
      self.viewed_date = Time.now 
      self.save
    end
  end

  def archive(user)

    if self.sender_user_id != user.id && self.recipient_user_id != user.id
      raise ApiAccessEvanta::PermissionDenied
    end

    if self.sender_user_id == user.id
      self.sender_deleted = 1
    end

    if self.recipient_user_id == user.id
      self.recipient_deleted = 1
    end

    self.save

    self

  end


  private 

    def check_permission
      self.sender_user.allowed_to_send_message?(self.recipient_user)
    end

end