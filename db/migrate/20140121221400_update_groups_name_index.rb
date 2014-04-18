class UpdateGroupsNameIndex < ActiveRecord::Migration
  def change
    execute "ALTER TABLE `groups` CHANGE `name` `name` VARCHAR(200)  CHARACTER SET utf8  COLLATE utf8_unicode_ci  NOT NULL  DEFAULT '';"
    add_index :groups, :name, :unique => true
  end
end
