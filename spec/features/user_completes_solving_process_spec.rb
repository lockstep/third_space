require 'rails_helper'

feature 'User completes solving process' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end
  scenario 'skips the intro wizard' do
    visit '/'
    click_on 'Skip'
    expect(page).to have_content('Write problem name here')
  end
  scenario 'creates new submission', js: true do
    visit '/problems/new'
    find(:href, "new-problem-textarea").trigger('click')
    fill_in 'new-problem-input', with: 'New submission'
    click_on 'Next'
    expect(page).to have_content 'What is a solution through this lens?'
    expect(page).to have_content 'What is your expected result?'
  end

  context 'existing submissions' do
    background do
      @problem = create(:problem)
      @input = create(:input)
    end
    scenario 'finalizes it' do
      visit '/problems/1/adaptability'
    end

    scenario 'goes back and edits' do
    end

    scenario 'edits from search' do
    end
  end
end
