class ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods
  include ActionController::MimeResponds
  include ActionController::StrongParameters

  rescue_from ActiveRecord::RecordNotFound, :with => :not_found
  rescue_from ActiveRecord::InvalidForeignKey, :with => :invalid_foreign_key
  rescue_from ApiAccessEvanta::PermissionDenied, :with => :permission_denied
  rescue_from ApiAccessEvanta::Unprocessable, :with => :unprocessable
  rescue_from ApiAccessEvanta::RecordOutOfScope, :with => :not_found
  
  before_filter :authenticate_user_from_token!


  # respond to options requests with blank text/plain as per spec responding to CORS request
  def cors_preflight_check
    render :text => '', :content_type => 'text/plain'
  end

  private
  
  def authenticate_user_from_token!
    return if request.env["REQUEST_METHOD"] == "OPTIONS"

    authenticate_with_http_token do |token, options|
      user_email = request.env["HTTP_X_API_EMAIL"].presence
      user       = user_email && User.find_by_email(user_email)
      if user && Devise.secure_compare(user.authentication_token, token)
        sign_in user, store: false
      end
    end

    throw(:warden) unless user_signed_in?
  end


  def authenticate_user_if_token
    authenticate_user_from_token! if request.env["HTTP_X_API_EMAIL"].present?
  end

  def not_found
    head :not_found
  end

  def invalid_foreign_key
    head :unprocessable_entity
  end

  def permission_denied
    head :forbidden
  end

  def unprocessable
    head :unprocessable_entity
  end

end
