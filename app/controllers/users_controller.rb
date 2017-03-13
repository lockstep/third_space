class UsersController < ApplicationController
  before_action :authenticate_user!

  def profile
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(update_password_params)
      bypass_sign_in(@user)
      redirect_to profile_path
    else
      render 'edit_password'
    end
  end

  def upload_avatar
    @user = User.find(current_user.id)
    if @user.update(upload_avatar_params)
      head :ok
    else
      render json: { error: @user.errors.messages[:avatar_content_type].first }
    end
  end

  private

  def upload_avatar_params
    params.require(:user).permit(:avatar)
  end

  def update_password_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
