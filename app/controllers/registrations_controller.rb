class RegistrationsController < Devise::RegistrationsController

  protected

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for(resource)
    users_path(resource)
  end

  private

  def sign_up_params
    params.require(:user).permit(:first_name, :last_name, :email, :password,
      :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:first_name, :last_name)
  end
end
