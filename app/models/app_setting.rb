class AppSetting < ActiveRecord::Base
  include User::Associations
  belongs_to :app_setting_option
  belongs_to :event
  belongs_to :group
  belongs_to :user_role
  belongs_to :user
  default_scope { order :app_setting_option_id }
  validate :app_setting_validation

  before_save :set_app_level_setting

  def app_setting_option_valid_for_user?(user)
    UserSettings.new(user).app_setting_options.map(&:id).include?(self.app_setting_option_id)
  end

  private

    def app_setting_validation
      errors.add(:app_setting, "type mismatch: event provided for a non event level app_setting") if event_id.present? && app_setting_option.app_setting_type_id != 2
      errors.add(:app_setting, "type mismatch: group provided for a non group level app_setting") if group_id.present? && app_setting_option.app_setting_type_id != 3
      errors.add(:app_setting, "type mismatch: user role provided for a non user role level app_setting") if user_role_id.present? && app_setting_option.app_setting_type_id != 4
      errors.add(:app_setting, "type mismatch: user provided for a non user level app_setting") if user_id.present? && app_setting_option.app_setting_type_id != 5
      errors.add(:app_setting, "type mismatch: (event, group, user, or user_role) provided for an app level app_setting") if (event_id.present? || group_id.present? || user_role_id.present? || user_id.present?) && app_setting_option.app_setting_type_id == 1
    end

    def set_app_level_setting
      if app_setting_option.app_setting_type_id == 1
        self.app_level_setting = 1
      else
        self.app_level_setting = nil
      end
    end

end
