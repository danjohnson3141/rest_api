class EventSession < ActiveRecord::Base
  include User::Associations
  belongs_to :sponsor
  belongs_to :event
  has_many :event_speakers
  has_one :post
  has_many :event_session_evaluations
  has_many :event_user_schedules
  has_many :event_session_evaluations
  has_many :event_sessions, through: :event_user_schedules
  belongs_to :breakout_group, class_name: 'Group', foreign_key: :breakout_group_id
  # before_destroy :remove_event_session_post_association



  default_scope { order(:start_date_time, :display_rank, :name) }

  def get_event_session_evaluations(user)
    return self.try(:event_session_evaluations) if self.show_event_session_evaluations?(user)
    return []
  end

  # For sessions with posts override session name to post title
  def session_name
    return self.post.title if self.post.present?
    self.name
  end

  # For sessions with posts override session description to post body
  def session_description
    return self.post.body if self.post.present?
    self.description
  end

  def comment_count
    EventNote.where(event_session_id: self.id).count
  end

  def like_count
    EventBookmark.where(event_session_id: self.id).count
  end

  def show_my_schedule?(user)
    AppSettings::Value.new(:event_my_schedule, user: user, event: self.event).on?
  end

  def show_event_notes?(user)
    AppSettings::Value.new(:event_notes, user: user, event: self.event).on?
  end

  def show_bookmarks?(user)
    AppSettings::Value.new(:event_bookmarks, user: user, event: self.event).on?
  end

  def show_event_session_evaluations?(user)
    AppSettings::Value.new(:event_session_evaluations, user: user, event: self.event).on?
  end

  def session_comments?(user)
    AppSettings::Value.new(:event_post_comments, user: user, event: self.event).on?
  end

  def breakout_group_member?(user)
    return if self.breakout_group_id.nil?
    user.group_member?(self.breakout_group)
  end

  def speakers
    self.event_speakers
  end

  def note_for_user(user)
    if show_event_notes?(user)
      EventNote.where(event_session_id: self.id).where(created_by: user.id).first
    end
  end

  def bookmark_for_user(user)
    if show_bookmarks?(user)
      EventBookmark.where(event_session_id: self.id).where(created_by: user.id).first
    end
  end

  def schedule_for_user(user)
    if show_my_schedule?(user)
      event_user = EventUser.where(event: self.event).where(user: user).first
      return if event_user.nil?
      EventUserSchedule.where(event_session: self).where(event_user: event_user).first
    end
  end

    private
      # def remove_event_session_post_association
      #   if event_session_post.present?
      #     if event_session_post.post_id.present?
      #       event_session_post.update_attribute(:event_session_id, nil)
      #     else
      #       event_session_post.destroy
      #     end
      #   end
      # end

      # def post_validation
      #   binding.pry
      #   errors.add(:event_session, "cannot be assigned a group post") if self.post.try(:group).present?
      # end


end
