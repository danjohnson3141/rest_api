class AddAppLabelPageToAppLabelDictionaries < ActiveRecord::Migration
  def change
    add_reference :app_label_dictionaries, :app_label_page, index: true
  end
end
