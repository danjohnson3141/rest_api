class SponsorType < ActiveRecord::Base
  include User::Associations
  has_many :sponsors
end
