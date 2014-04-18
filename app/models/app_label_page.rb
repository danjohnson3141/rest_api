class AppLabelPage < ActiveRecord::Base
  include User::Associations
  has_many :app_label_dictionary
  has_many :app_labels, through: :app_label_dictionary

  def require_auth?
  	self.auth_required
  end
end
