module ControllerMacros
  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in(@user, scope: :user)
    end
  end

  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      @user = FactoryGirl.create(:user, :admin)
      sign_in(@user, scope: :user)
    end
  end
end
