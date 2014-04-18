require 'spec_helper'

describe 'AppLabels' do

  before(:all) do
    @user = create(:user)
  end

  it "GET /app/labels/:page; requests a page that exists, auth not required" do
    app_label_dictionary = create(:app_label_dictionary)
    
    get "/app/labels/#{app_label_dictionary.app_label_page.name}"
    response.status.should eql(200)
    json["app_label_pages"].first["key"].should eq(app_label_dictionary.key)
    json["app_label_pages"].first["label"].should eq(app_label_dictionary.name)
  end

  it "GET /app/labels/:page; requests a page that exists, auth required, user not authorized, 401" do
    app_label_dictionary = create(:app_label_dictionary, :auth_required)
    get "/app/labels/#{app_label_dictionary.app_label_page.name}"
    response.status.should eql(401)
  end
     
  it "GET /app/labels/:page; requests a page that doesn't exist" do
    get '/app/labels/not_a_real_page'
    response.status.should eql(404)
  end

end