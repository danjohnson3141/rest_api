class AppLabelDictionary < ActiveRecord::Base
  include User::Associations
  belongs_to :app_label_page
  has_one :app_label

  after_create :create_app_label

  def create_app_label
    if AppLabel.where(app_label_dictionary_id: self.id).first.nil?
      AppLabel.create(label: self.name, label_plural: self.name_plural, app_label_dictionary_id: self.id)
    end
  end
end
