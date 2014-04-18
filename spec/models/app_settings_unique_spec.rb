require 'spec_helper'

describe 'AppSettings' do  
  
  it 'App uniqueness' do
    app_setting_option = AppSettingOption.find(21)
    create(:app_setting, app_setting_option: app_setting_option, app_level_setting: 1)
    begin
      create(:app_setting, app_setting_option: app_setting_option, app_level_setting: 1)
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordNotUnique
    end
    AppSetting.count.should eq 1
  end

  it 'App uniqueness' do
    app_setting_option = AppSettingOption.find(21)
    create(:app_setting, app_setting_option: app_setting_option)
    begin
      create(:app_setting, app_setting_option: app_setting_option)
    rescue Exception => e  
      e.class.should eq ActiveRecord::RecordNotUnique
    end
    AppSetting.count.should eq 1
  end


  it 'Event uniqueness' do
    app_setting_option = AppSettingOption.find(141)
    event = create(:event, :random)
    create(:app_setting, app_setting_option: app_setting_option, event: event)
    begin
      create(:app_setting, app_setting_option: app_setting_option, event: event)
    rescue Exception => e
      e.class.should eq ActiveRecord::RecordNotUnique
    end
    AppSetting.count.should eq 1
  end

  it 'Event uniqueness' do
    app_setting_option = AppSettingOption.find(141)
    event1 = create(:event, :random)
    event2 = create(:event, :random)
    create(:app_setting, app_setting_option: app_setting_option, event: event1)
    create(:app_setting, app_setting_option: app_setting_option, event: event2)
  end

  it 'Group uniqueness' do
    app_setting_option = AppSettingOption.find(11)
    group = create(:group, :open)
    create(:app_setting, app_setting_option: app_setting_option, group: group)
    begin
      create(:app_setting, app_setting_option: app_setting_option, group: group)
    rescue Exception => e
      e.class.should eq ActiveRecord::RecordNotUnique
    end
    AppSetting.count.should eq 1
  end

  it 'Group uniqueness' do
    app_setting_option = AppSettingOption.find(11)
    group1 = create(:group, :open)
    group2 = create(:group, :open)
    create(:app_setting, app_setting_option: app_setting_option, group: group1)
    create(:app_setting, app_setting_option: app_setting_option, group: group2)
  end

  it 'User-role uniqueness' do
    app_setting_option = AppSettingOption.find(3)
    user = create(:user, :random)
    create(:app_setting, app_setting_option: app_setting_option, user_role: user.user_role)
    begin
      create(:app_setting, app_setting_option: app_setting_option, user_role: user.user_role)
    rescue Exception => e
      e.class.should eq ActiveRecord::RecordNotUnique
    end
    AppSetting.count.should eq 1
  end

  it 'User-role uniqueness' do
    app_setting_option = AppSettingOption.find(3)
    user1 = create(:user, :member, :random)
    user2 = create(:user, :sponsor, :random)
    create(:app_setting, app_setting_option: app_setting_option, user_role: user1.user_role)
    create(:app_setting, app_setting_option: app_setting_option, user_role: user2.user_role)
  end

  it 'User uniqueness' do
    app_setting_option = AppSettingOption.find(18)
    user = create(:user, :random)
    create(:app_setting, app_setting_option: app_setting_option, user: user)
    begin
      create(:app_setting, app_setting_option: app_setting_option, user: user)
    rescue Exception => e
      e.class.should eq ActiveRecord::RecordNotUnique
    end
    AppSetting.count.should eq 1
  end

  it 'User uniqueness' do
    app_setting_option = AppSettingOption.find(18)
    user1 = create(:user, :random)
    user2 = create(:user, :random)
    create(:app_setting, app_setting_option: app_setting_option, user: user1)
    create(:app_setting, app_setting_option: app_setting_option, user: user2)
  end

end