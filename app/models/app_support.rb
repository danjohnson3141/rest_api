class AppSupport < ActiveRecord::Base
  include User::Associations
  validates :body, presence: true, length: { maximum: 2000 }
  validate :check_email_addresses

  def check_email_addresses
    return true if !email?
    unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
      errors.add(:email, "invalid email address: #{email}")
    end
  end
end
