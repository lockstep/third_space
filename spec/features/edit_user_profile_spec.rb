require 'rails_helper'

feature 'Edit User Profile' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  scenario 'updates name successfully' do
    visit users_path
    click_on 'edit profile'
    fill_in 'user_first_name', with: 'Tom'
    fill_in 'user_last_name', with: 'Cruise'
    click_on 'update'
    expect(page).to have_content 'Tom'
    expect(page).to have_content 'Cruise'
  end

  scenario 'updates name unsuccessfully' do
    visit users_path
    click_on 'edit profile'
    fill_in 'user_first_name', with: ''
    fill_in 'user_last_name', with: ''
    click_on 'update'
    expect(page).to have_content "First name can't be blank."
    expect(page).to have_content "Last name can't be blank."
  end

  scenario 'updates password successfully' do
    visit users_path
    click_on 'edit profile'
    click_on 'Change your password'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    fill_in 'user_current_password', with: 'password'
    click_on 'update'
    expect(page).to have_content 'Successfully updated password'
  end

  scenario 'updates password unsuccessfully' do
    visit users_path
    click_on 'edit profile'
    click_on 'Change your password'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    fill_in 'user_current_password', with: ''
    click_on 'update'
    expect(page).to have_content "Current password can't be blank."
  end
end
