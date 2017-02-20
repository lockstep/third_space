require 'rails_helper'

feature 'View User Profile' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  scenario 'renders profile page correctly' do
    visit users_path
    expect(page).to have_content @user.first_name
    expect(page).to have_content @user.last_name
    expect(page).to have_content @user.email
    expect(page).to have_link('edit profile')
  end
end
