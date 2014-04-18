class AppSettingOption < ActiveRecord::Base
  include User::Associations
  has_many :app_settings
  has_many :app_setting_dependencies
  has_many :dependent_app_setting_dependencies, class_name: 'AppSettingDependency', foreign_key: :dependent_app_setting_option_id

  belongs_to :app_setting_type

  scope :user, -> { where(app_setting_type_id: 5).order(:description) }

  def self.cached_find(params)
    Rails.cache.fetch($tenant.name_space([:app_setting_option, params])) do
      find(params)
    end
  end


  # Climbs the tree to find all dependencies. (recursive)
  def all_dependencies
    dependencies = []
    dependencies << self.id

    self.app_setting_dependencies.each do |dependency|
      dependencies << dependency.dependent_app_setting_option_id
      dependencies << dependency.dependent_app_setting_option.all_dependencies
    end
    dependencies.flatten!
    dependencies.uniq!

    dependencies
  end


  def dependencies_grouped_by_types

    Rails.cache.fetch($tenant.name_space([:app_setting_option, :dependencies_grouped_by_types, self.id])) do
      grouped_dependencies = {}
      AppSettingOption.includes(:app_setting_type).find(all_dependencies).each do |option|
        grouped_dependencies[option.app_setting_type.name] ||= []
        grouped_dependencies[option.app_setting_type.name] << option.id
      end
      grouped_dependencies

    end

  end


end
