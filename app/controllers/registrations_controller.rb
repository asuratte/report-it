class RegistrationsController < Devise::RegistrationsController
    private
      def sign_up_params
        params.require(:user).permit(:email, :password, :first_name, :last_name, :address1, :city, :state, :zip, :phone, :username)
      end
  end