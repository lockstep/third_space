class RegistrationsController < Devise::RegistrationsController

  protected

  def sign_up(resource_name, user)
    super
    user.add_company
  end

  def after_sign_up_path_for(resource)
    wizard_path
  end

  def after_inactive_sign_up_path_for(resource)
    wizard_path
  end

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
    params.require(:user).permit(:first_name, :last_name, :avatar)
  end
end
