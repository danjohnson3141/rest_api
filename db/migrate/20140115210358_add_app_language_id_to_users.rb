class AddAppLanguageIdToUsers < ActiveRecord::Migration
  def change
    add_reference :users, :app_language, index: true, after: :bio
  end
end
