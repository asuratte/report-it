class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected
      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :first_name, :last_name, :address1, :address2, :city, :state, :zip, :phone, :username])
        devise_parameter_sanitizer.permit(:account_update, keys: [:email, :password, :first_name, :last_name, :address1, :address2, :city, :state, :zip, :phone, :username])
      end

  end