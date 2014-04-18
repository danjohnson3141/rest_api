class MoveAppLabelPageIdInAppLabelDictionaries < ActiveRecord::Migration
  def change
    # Moves app_label_page_id column
    execute "ALTER TABLE `app_label_dictionaries` MODIFY COLUMN `app_label_page_id` INT(11) DEFAULT NULL AFTER `description`;"
  end
end
