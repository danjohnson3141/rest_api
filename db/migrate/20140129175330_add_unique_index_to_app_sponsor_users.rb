class AddUniqueIndexToAppSponsorUsers < ActiveRecord::Migration
  def change
    add_index :app_sponsor_users, [:app_sponsor_id, :user_id], :unique => true
  end
end
