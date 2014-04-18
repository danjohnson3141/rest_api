class AddFksToAppSupport < ActiveRecord::Migration
  def change
  	add_foreign_key :app_supports, :users, column: 'created_by'
  	add_foreign_key :app_supports, :users, column: 'updated_by'
  end
end
