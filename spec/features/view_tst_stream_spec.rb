require 'rails_helper'

feature 'View TST Stream' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  scenario 'renders pagination correctly' do
    create_list(:problem, 30, user: @user)
    create(:problem, name: 'On second page', user: @user)

    visit problems_path
    expect(page).to have_content('My Problem')
    expect(page).not_to have_content("On second page")

    click_on '2'
    expect(page).to have_content("On second page")
    expect(page).not_to have_content('My Problem')
  end
end
