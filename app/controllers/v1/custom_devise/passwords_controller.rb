module V1
  module CustomDevise
    class PasswordsController < Devise::PasswordsController

      skip_before_filter :authenticate_user_from_token!

      # Render the #edit only if coming from a reset password email link
      append_before_filter :assert_reset_token_passed, :only => :edit
      include Devise::Controllers::Helpers
      respond_to :json

      # PUT /resource/password
      def update
        self.resource = resource_class.reset_password_by_token(resource_params)

        if resource.errors.empty?
          render :nothing => true, :status => :ok
        else
          render json: { errors: resource.errors }, status: :forbidden
        end
      end


      # POST /users/password
      def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)

        if resource.errors.empty?
          render :nothing => true, :status => :created
        else
          render json: { errors: resource.errors }, status: :forbidden
        end
      end

    end
  end
end