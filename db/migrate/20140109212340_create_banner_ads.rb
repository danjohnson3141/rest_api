class CreateBannerAds < ActiveRecord::Migration
  def change
    create_table :banner_ads do |t|
      t.references :group, index: true
      t.references :event, index: true
      t.text :graphic_link
      t.integer :app_sponsor_id
      t.references :event_sponsor, index: true
      t.string :link_url, limit: 100
      t.integer :created_by
      t.integer :updated_by

      t.timestamps
    end
    add_index :banner_ads, :app_sponsor_id
    add_index :banner_ads, :created_by
    add_index :banner_ads, :updated_by
  end
end
