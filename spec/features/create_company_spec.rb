require 'rails_helper'

feature 'Create Company' do
  background do
    @user = create(:user, role: 'admin')
    login_as(@user, scope: :user)
  end

  scenario 'creates company successfully' do
    visit '/admin'
    click_on 'Companies'
    click_on 'New company'
    fill_in 'company_name', with: 'apple'
    fill_in 'company_domain_name', with: 'apple.com'
    click_on 'Create Company'
    expect(page).to have_content 'Company was successfully created'
  end
end
