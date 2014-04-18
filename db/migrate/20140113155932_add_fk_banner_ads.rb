class AddFkBannerAds < ActiveRecord::Migration
  def up
    change_table :banner_ads do |t|
      t.foreign_key :groups
      t.foreign_key :events
      t.foreign_key :app_sponsors
      t.foreign_key :event_sponsors
      t.foreign_key :users, column: 'updated_by'
      t.foreign_key :users, column: 'created_by'
    end
  end
  def down
    remove_foreign_key(:banner_ads, name: 'banner_ads_created_by_fk')
    remove_foreign_key(:banner_ads, name: 'banner_ads_updated_by_fk')
    remove_foreign_key(:banner_ads, :groups)
    remove_foreign_key(:banner_ads, :events)
    remove_foreign_key(:banner_ads, :app_sponsors)
    remove_foreign_key(:banner_ads, :event_sponsors)
  end
end
