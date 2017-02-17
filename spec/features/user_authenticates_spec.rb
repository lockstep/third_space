require 'rails_helper'

feature 'Authentication:' do
  context 'existing user' do
    background do
     @user = create(:user)
    end
    scenario 'signs in successfully' do
      visit '/'
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: 'password'
      click_on 'Sign in'
      expect(page).to have_content('Skip')
    end
    scenario 'signs in unsuccessfully' do
      visit '/'
      fill_in 'user_email', with: 'test@example.com'
      fill_in 'user_password', with: 'wrong_password'
      click_on 'Sign in'
      expect(page).to have_content('Invalid Email or password.')
    end
    scenario 'requests new password' do
      visit '/'
      click_on 'Forgot Password?'
      fill_in 'user_email', with: @user.email
      click_on 'Reset password'
      expect(page).to have_content('You will receive an email with instructions on how to reset your password in a few minutes.')
    end
  end
  context 'new user' do
    scenario 'signs up successfully' do
      visit '/'
      click_on 'Create Account'
      fill_in 'user_first_name', with: 'donale'
      fill_in 'user_last_name', with: 'trump'
      fill_in 'user_email', with: 'foo@example.com'
      fill_in 'user_password', with: 'password'
      fill_in 'user_password_confirmation', with: 'password'
      click_on 'Sign up'
      expect(page).to have_content('Skip')
    end
    scenario 'gets redirected to login page' do
      visit '/problems'
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
  context 'admin user' do
    background do
      @user = create(:user, role: 'admin')
    end
    scenario 'not unauthenticated gets redirected to sign in page' do
      visit '/admin'
      expect(page).to have_current_path(new_user_session_path)
    end
    scenario 'successfully logs in' do
      visit '/admin'
      fill_in 'user_email', with: @user.email
      fill_in 'user_password', with: 'password'
      click_on 'Sign in'
      expect(page).to have_content('Signed in successfully.')
      expect(page).to have_current_path(admin_root_path)
    end
  end
end
