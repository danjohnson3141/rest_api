module V1
  module CustomDevise
    class SessionsController < Devise::SessionsController
      prepend_before_filter :require_no_authentication, :only => [:create ]
      include Devise::Controllers::Helpers

      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        resource.ensure_authentication_token
        resource.save!
        render json: {
          success: true,
          auth_token: resource.authentication_token
        }
      end

      def destroy
        sign_out(resource_name)
      end

    end
  end
end