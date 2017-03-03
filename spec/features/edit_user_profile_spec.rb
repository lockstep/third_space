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
    expect(page).to have_content "First name can't be blank"
    expect(page).to have_content "Last name can't be blank"
  end

  scenario 'updates password successfully' do
    visit users_path
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
    visit users_path
    click_on 'edit profile'
    click_on 'Change your password'
    fill_in 'user_password', with: '123456'
    fill_in 'user_password_confirmation', with: '123456'
    fill_in 'user_current_password', with: ''
    click_on 'update'
    expect(page).to have_content "Current password can't be blank"
  end

  context 'user is going to upload an avatar' do
    scenario 'user can see default avatar before upload' do
      visit users_path
      click_on 'edit profile'
      expect(page).to have_css("img[src*='default_avatar']")
    end

    scenario 'successfully upload' do
      allow_any_instance_of(Paperclip::Attachment).to receive(:save)
         .and_return(true)

      visit users_path
      click_on 'edit profile'
      attach_file 'user_avatar', "spec/fixtures/paperclip/avatar.png"
      click_button 'update'
      expect(page).to have_content @user.first_name
      expect(page).to have_content @user.last_name
      expect(page).to have_content @user.email
    end

    context 'invalid image formats' do
      xscenario 'unsuccessfully upload' do
        ['avatar.gif', 'fake_avatar.txt'].each do |filename|
          visit users_path
          click_on 'edit profile'
          attach_file 'user_avatar', "spec/fixtures/paperclip/#{filename}"
          click_button 'update'
          expect(page).to have_content 'Uploaded file is not a valid image'
        end
      end
    end
  end
end
