require 'rails_helper'

feature 'View TST Stream' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  context 'TST Stream' do
    background do
      create(:problem, name: 'my problem', user: @user)
      create(:problem, name: "Somebody else's problem", user: create(:user))
    end

    scenario 'views my problem' do
      visit problems_path
      click_link 'My'
      expect(page).to have_content 'my problem'
      expect(page).to_not have_content "Somebody else's problem"
    end

    scenario 'views all problem' do
      visit problems_path
      click_link 'All'
      expect(page).to have_content 'my problem'
      expect(page).to have_content "Somebody else's problem"
    end
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
