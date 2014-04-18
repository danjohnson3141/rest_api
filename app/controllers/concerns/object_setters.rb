module ObjectSetters
  extend ActiveSupport::Concern

  def set_object(model)
    value = model.find(get_param_value(model))
    instance_variable_set("@" + model.class_name.underscore, value)
  end

  private 
    def get_param_value(model)
      
      if params[model.class_name.downcase + "_id"].present?
        return params[model.class_name.downcase + "_id"] 
      else
        return params[:id] unless params[:id].nil?
      end
      
      return nil
    end


end