class EventBookmark < ActiveRecord::Base
  include User::Associations
  include Event::Related

  validate :valid_event_bookmark

  def my_bookmark?(user)
    created_by == user
  end

  def self.for_event(event: event=nil, user: user=nil)
    return if event.nil?
    return if user.nil?
    EventBookmark.
    joins("LEFT JOIN `event_users` ON `event_users`.`id` = `event_bookmarks`.`event_user_id`").
    joins("LEFT JOIN `event_sessions` ON `event_sessions`.`id` = `event_bookmarks`.`event_session_id`").
    joins("LEFT JOIN `sponsors` ON `sponsors`.`id` = `event_bookmarks`.`sponsor_id`").
    joins("LEFT JOIN `event_speakers` ON `event_speakers`.`id` = `event_bookmarks`.`event_speaker_id`").
    joins("LEFT JOIN `event_sessions` `es` ON `event_speakers`.`event_session_id` = `es`.`id`").
    where("`event_users`.`event_id` = ? OR `sponsors`.`event_id` = ? OR `event_sessions`.`event_id` = ? OR `es`.`event_id` = ?", event.id, event.id, event.id, event.id).
    where(created_by: user).order("created_at DESC")
  end


  private
    def valid_event_bookmark
      count = 0
      count += 1 if !event_user_id.nil?
      count += 1 if !sponsor_id.nil?
      count += 1 if !event_session_id.nil?
      count += 1 if !event_speaker_id.nil?

      if count != 1
         errors.add(:event_bookmarks, "Please provide only one of the following: event_user_id, sponsor_id, event_speaker_id, or event_session_id.")
      end

    end
end