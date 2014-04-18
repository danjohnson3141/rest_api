class CustomAuthFailure < Devise::FailureApp
  def respond
    self.status = 401 
    self.content_type = 'json'
    self.response_body = {"errors" => [message]}.to_json
  end

  def message
    return "account_disabled" if self.env["warden.options"][:message] == :inactive
    "access_denied"
  end

end