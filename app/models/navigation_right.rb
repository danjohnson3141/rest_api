class NavigationRight

  include ActiveModel::Serialization

  def initialize(current_user, event)
    @user = current_user
    @event = event
  end

  # 16, 14
  def show_attendees
    AppSettings::Value.new(__method__, user: @user, event: @event).on?
  end

  # 141, 142
  def show_sessions
    AppSettings::Value.new(:event_sessions, user: @user, event: @event).on?
  end

  # 170, 171
  def show_my_schedule
    AppSettings::Value.new(:event_my_schedule, user: @user, event: @event).on?
  end

  # 138, 139
  def show_sponsors
    AppSettings::Value.new(:event_sponsors, user: @user, event: @event).on?
  end

  # 144, 145
  def show_speakers
    AppSettings::Value.new(:event_speakers, user: @user, event: @event).on?
  end

  # 173, 174
  def show_qr_scannable
    AppSettings::Value.new(:event_qr_scannable, user: @user, event: @event).on?
  end

  # 173, 175
  def show_qr_scanner
    AppSettings::Value.new(:event_qr_scanner, user: @user, event: @event).on?
  end

  # 147, 148
  def show_event_notes
    AppSettings::Value.new(:event_notes, user: @user, event: @event).on?
  end

  # 150, 151
  def show_bookmarks
    AppSettings::Value.new(:event_bookmarks, user: @user, event: @event).on?
  end

  # 159, 160
  def show_leaderboard
    AppSettings::Value.new(:event_leaderboard, user: @user, event: @event).on?
  end

  # 167, 168
  def show_leaderboard_rules
    AppSettings::Value.new(__method__, user: @user, event: @event).on?
  end

  # 153
  def show_event_evaluations
    AppSettings::Value.new(:event_evaluations, user: @user, event: @event).on?
  end



end