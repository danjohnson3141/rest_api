require 'spec_helper'

describe 'UsersSignOut' do

  it "DELETE /users/sign_out; logs the user out" do
    user = create(:user)
    delete_auth '/users/sign_out', nil, {"HTTP_AUTHORIZATION" => 'Token token="54321"', "HTTP_X_API_EMAIL" => "bluehawk@evanta.com"}
    response.status.should eql(200) 
  end 

end