class EventRegistrationStatus < ActiveRecord::Base
  include User::Associations
  validates :key, uniqueness: true
  belongs_to :app_label_dictionary
end
