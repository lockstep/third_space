require 'rails_helper'

feature 'Edit User Profile' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  scenario 'updates name successfully' do
    visit profile_path
    click_on 'edit profile'
    fill_in 'user_first_name', with: 'Tom'
    fill_in 'user_last_name', with: 'Cruise'
    click_on 'update'
    expect(page).to have_content 'Tom'
    expect(page).to have_content 'Cruise'
  end

  scenario 'updates name unsuccessfully' do
    visit profile_path
    click_on 'edit profile'
    fill_in 'user_first_name', with: ''
    fill_in 'user_last_name', with: ''
    click_on 'update'
    expect(page).to have_content "First name can't be blank"
    expect(page).to have_content "Last name can't be blank"
  end

  scenario 'updates password successfully' do
    visit profile_path
    click_on 'edit profile'
    click_on 'Change your password'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    fill_in 'user_current_password', with: 'password'
    click_on 'update'
    expect(page).to have_content @user.first_name
    expect(page).to have_content @user.last_name
    expect(page).to have_content @user.email
  end

  scenario 'updates password unsuccessfully' do
    visit profile_path
    click_on 'edit profile'
    click_on 'Change your password'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    fill_in 'user_current_password', with: ''
    click_on 'update'
    expect(page).to have_content "Current password can't be blank"
  end

  context 'user is going to upload an avatar', js: true do
    scenario 'user can see default avatar before upload' do
      visit profile_path
      click_on 'edit profile'
      expect(page).to have_css("img[src*='default_avatar']")
    end

    scenario 'successfully upload' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save)
         .and_return(true)
      expect(User.first.avatar_file_name).to be_nil

      visit edit_user_registration_path
      execute_script("$('#user_avatar').css('display','block')")
      attach_file 'user_avatar', 'spec/fixtures/paperclip/avatar.png'
      wait_for_ajax

      expect(User.first.avatar_file_name).to eq 'avatar.png'
    end

    context 'invalid image formats' do
      scenario 'unsuccessfully upload' do
        allow_any_instance_of(Paperclip::Attachment).to receive(:save)
           .and_return(false)

        visit edit_user_registration_path
        execute_script("$('#user_avatar').css('display','block')")
        attach_file 'user_avatar', "spec/fixtures/paperclip/avatar.gif"

        expect(page).to have_content 'Uploaded file is not a valid image'
      end
    end
  end
end
