class AppLabel < ActiveRecord::Base
  include User::Associations
  translates :label
  belongs_to :app_label_dictionary
end
