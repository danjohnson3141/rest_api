class BannerAd < ActiveRecord::Base
  include User::Associations
  belongs_to :sponsor
end
