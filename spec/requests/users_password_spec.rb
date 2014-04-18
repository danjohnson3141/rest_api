require 'spec_helper'

describe 'UsersPassword' do

  it "POST /users/password; success - send email" do
   user = create(:user)
   
   post '/users/password', { user: { email: user.email } }
   response.status.should eql(201) 
   email = ActionMailer::Base.deliveries.first
   email.to.should eq [user.email]
   email.from.should eq ["support@evantaccess.com"]
   email.subject.should eq "Reset password instructions"

   doc = Nokogiri::HTML(email.body.raw_source)
   token = URI.parse(doc.search('a').first['href']).fragment.split("/")[1]
   reset_user = User.find(user.id)
   reset_user.reset_password_token.should eq Devise.token_generator.digest(reset_user, :reset_password_token, token)
  end    

  it "PATCH /users/password; success - update password" do
   user = create(:user)
   reset_user = User.find(user.id)
   reset_user.reset_password_token = "bc50f0a6a52c3532a311dfda3d9a424828ab6bfd4d18dd08ef23119afc6ec697"
   reset_user.reset_password_sent_at = Time.now - 10.minutes
   reset_user.save

   patch '/users/password', { user: { reset_password_token: "S8cL7iZCLrX3WURW2vaN",  password: "evanta2015", password_confirmation: "evanta2015" } }
   response.status.should eql(200)    
  end  

  it "PUT /users/password; success - update password" do
   user = create(:user)
   reset_user = User.find(user.id)
   reset_user.reset_password_token = "bc50f0a6a52c3532a311dfda3d9a424828ab6bfd4d18dd08ef23119afc6ec697"
   reset_user.reset_password_sent_at = Time.now - 10.minutes
   reset_user.save

   put '/users/password', { user: { reset_password_token: "S8cL7iZCLrX3WURW2vaN",  password: "evanta2015", password_confirmation: "evanta2015" } }
   response.status.should eql(200)    
  end

  it "PATCH /users/password; expired token" do
   user = create(:user)
   reset_user = User.find(user.id)
   reset_user.reset_password_token = "bc50f0a6a52c3532a311dfda3d9a424828ab6bfd4d18dd08ef23119afc6ec697"
   reset_user.reset_password_sent_at = Time.now - 2.days
   reset_user.save

   patch '/users/password', { user: { reset_password_token: "S8cL7iZCLrX3WURW2vaN",  password: "evanta2015", password_confirmation: "evanta2015" } }
   response.status.should eql(403)
   json["errors"]["reset_password_token"].should eq ["has expired, please request a new one"]
  end

  it "PATCH /users/password; invalid token" do
   user = create(:user)
   reset_user = User.find(user.id)
   reset_user.reset_password_token = "bc50f0a6a52c3532a311dfda3d9a424828ab6bfd4d18dd08ef23119afc6ec697"
   reset_user.reset_password_sent_at = Time.now - 10.minutes
   reset_user.save

   patch '/users/password', { user: { reset_password_token: "xxxxxxxxxxxxxxxxxxx",  password: "evanta2015", password_confirmation: "evanta2015" } }
   response.status.should eql(403)
   json["errors"]["reset_password_token"].should eq ["is invalid"]
  end

  it "PATCH /users/password; missing user - PATCH" do
   patch '/users/password', { user: { reset_password_token: "S8cL7iZCLrX3WURW2vaN",  password: "evanta2015", password_confirmation: "evanta2015" } }
   
   response.status.should eql(403)
   json["errors"]["reset_password_token"].should eq ["is invalid"]
  end

  it "POST /users/password; missing user - POST" do
   post '/users/password', { user: { email: "bluehawk@evanta.com" } }
   
   response.status.should eql(403)
   json["errors"]["email"].should eq ["not found"]
  end    

  it "PATCH /users/password; password mismatch" do
   user = create(:user)
   
   reset_user = User.find(user.id)
   reset_user.reset_password_token = "bc50f0a6a52c3532a311dfda3d9a424828ab6bfd4d18dd08ef23119afc6ec697"
   reset_user.reset_password_sent_at = Time.now - 10.minutes
   reset_user.save

   patch '/users/password', { user: { reset_password_token: "S8cL7iZCLrX3WURW2vaN",  password: "evanta2015", password_confirmation: "evanta2016" } }
   response.status.should eql(403)
   json["errors"]["password_confirmation"].should eq ["doesn't match Password"]
  end

end