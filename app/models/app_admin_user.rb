class AppAdminUser < ActiveRecord::Base
  include User::Associations
  belongs_to :user
end
