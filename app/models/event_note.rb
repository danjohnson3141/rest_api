class EventNote < ActiveRecord::Base
  include User::Associations
  include Event::Related

  belongs_to :event_user
  belongs_to :event_speaker
  belongs_to :event_session
  belongs_to :sponsor

  validates :body, presence: true
  validate :valid_event_note

  def self.for_event(event: event=nil, user: user=nil)
    return if event.nil?
    return if user.nil?
    EventNote.joins("LEFT JOIN `event_users` ON `event_users`.`id` = `event_notes`.`event_user_id`").
    joins("LEFT JOIN `event_sessions` ON `event_sessions`.`id` = `event_notes`.`event_session_id`").
    joins("LEFT JOIN `sponsors` ON `sponsors`.`id` = `event_notes`.`sponsor_id`").
    joins("LEFT JOIN `event_speakers` ON `event_speakers`.`id` = `event_notes`.`event_speaker_id`").
    joins("LEFT JOIN `event_sessions` `es2` ON `event_speakers`.`event_session_id` = `es2`.`id`").
    where("`event_users`.`event_id` = ? OR `sponsors`.`event_id` = ? OR `event_sessions`.`event_id` = ? OR `es2`.`event_id` = ?", event.id, event.id, event.id, event.id).
    where(created_by: user).order("created_at DESC")
  end

  private
    def valid_event_note
      count = 0
      count += 1 if !event_user_id.nil?
      count += 1 if !sponsor_id.nil?
      count += 1 if !event_session_id.nil?
      count += 1 if !event_speaker_id.nil?

      if count != 1
         errors.add(:event_notes, "Please provide only one of the following: event_user_id, sponsor_id, event_speaker_id, or event_session_id.")
      end

    end
end
