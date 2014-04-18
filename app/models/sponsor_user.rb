class SponsorUser < ActiveRecord::Base
  include User::Associations
  belongs_to :sponsor
  belongs_to :user

  validates :user_id, presence: true, uniqueness: { scope: :sponsor_id }
  validates :sponsor_id, presence: true
end
