class UserRole < ActiveRecord::Base
  include User::Associations
end
