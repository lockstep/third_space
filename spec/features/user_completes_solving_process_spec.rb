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
    end

    scenario 'goes back and edits' do
      visit "/problems/#{@problem.id}/#{@input.lens}"
      expect(page).to have_content @input.input_text
      find(:href, "result-textarea").click
      fill_in 'result-input', with: 'Updated text'
      find(:href, "result-textarea").click
      expect(page).to have_content 'Updated text'
      expect(page).not_to have_content @input.input_text
    end

    scenario 'edits from search' do
    end
  end
end
