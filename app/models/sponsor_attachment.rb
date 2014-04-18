class SponsorAttachment < ActiveRecord::Base
  include User::Associations
  belongs_to :sponsor
end
