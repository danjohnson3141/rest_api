require 'spec_helper'

describe 'AppSettings' do  
  
  before(:all) do
    @user = create(:user)
    @event = create(:event, :random)
  end  

  it 'show_likes_count on' do
    AppSettings::Value.new(:show_likes_count, user: @user).on?.should eq true
  end

  it 'show_likes_count off' do
    create(:app_setting, app_setting_option_id: 32, user: @user)    
    AppSettings::Value.new(:show_likes_count, user: @user).off?.should eq true
  end

  it 'show_likes_count off' do
    create(:app_setting, app_setting_option_id: 31, user_role: @user.user_role)    
    AppSettings::Value.new(:show_likes_count, user: @user).off?.should eq true
  end

  it 'show_likes_count off' do
    create(:app_setting, app_setting_option_id: 32, user: @user)    
    create(:app_setting, app_setting_option_id: 31, user_role: @user.user_role)    
    AppSettings::Value.new(:show_likes_count, user: @user).off?.should eq true
  end

  it 'show_likes_count off' do
    create(:app_setting, app_setting_option_id: 109)
    AppSettings::Value.new(:show_likes_count, user: @user).off?.should eq true
  end

  it 'An event level app_setting must have an event_id; cannot have group_id, user_role_id, or user_id. app_level_setting should be nil' do
    AppSetting.create(app_setting_option_id: 110, event: @event).valid?.should eq true
    AppSetting.where(app_setting_option_id: 110, event: @event, app_level_setting: nil).present?.should eq true
    AppSetting.create(app_setting_option_id: 110, group: @event.group).valid?.should eq false
    AppSetting.create(app_setting_option_id: 110, user_role: @user.user_role).valid?.should eq false
    AppSetting.create(app_setting_option_id: 110, user: @user).valid?.should eq false
  end

  it 'A group level app_setting must have an group_id; cannot have event_id, user_role_id, or user_id. app_level_setting should be nil' do
    AppSetting.create(app_setting_option_id: 111, group: @event.group).valid?.should eq true
    AppSetting.where(app_setting_option_id: 111, group: @event.group, app_level_setting: nil).present?.should eq true
    AppSetting.create(app_setting_option_id: 111, event: @event).valid?.should eq false
    AppSetting.create(app_setting_option_id: 111, user_role: @user.user_role).valid?.should eq false
    AppSetting.create(app_setting_option_id: 111, user: @user).valid?.should eq false
  end

  it 'A user_role level app_setting must have an user_role_id; cannot have event_id, group_id, or user_id. app_level_setting should be nil' do
    AppSetting.create(app_setting_option_id: 112, user_role: @user.user_role).valid?.should eq true
    AppSetting.where(app_setting_option_id: 112, user_role: @user.user_role, app_level_setting: nil).present?.should eq true
    AppSetting.create(app_setting_option_id: 112, event: @event).valid?.should eq false
    AppSetting.create(app_setting_option_id: 112, group: @event.group).valid?.should eq false
    AppSetting.create(app_setting_option_id: 112, user: @user).valid?.should eq false
  end

  it 'A user level app_setting must have an user_id; cannot have event_id, group_id, or user_role_id. app_level_setting should be nil' do
    AppSetting.create(app_setting_option_id: 119, user: @user).valid?.should eq true
    AppSetting.where(app_setting_option_id: 119, user: @user, app_level_setting: nil).present?.should eq true
    AppSetting.create(app_setting_option_id: 119, event: @event).valid?.should eq false
    AppSetting.create(app_setting_option_id: 119, group: @event.group).valid?.should eq false
    AppSetting.create(app_setting_option_id: 119, user_role: @user.user_role).valid?.should eq false
  end


end
