class UsersController < ApplicationController
  def show
  end

  def edit_password
    @user = current_user
  end

  def update_password
    @user = User.find(current_user.id)
    if @user.update_with_password(user_params)
      bypass_sign_in(@user)
      redirect_to users_path, notice: 'Successfully updated password'
    else
      render 'edit_password'
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end
end
