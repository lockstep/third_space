require 'rails_helper'

feature 'Create Problem Spec' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  scenario 'skips the intro wizard' do
    visit '/'
    click_on 'Skip'
    expect(page).to have_content('What is your problem name?')
  end

  context 'creates a problem', js: true do
    background { visit new_problem_path }
    scenario 'creates a problem successfull' do
      fill_in 'new-problem-input', with: 'global warming'
      click_on 'Next'

      %w(adaptability cultural_competence empathy intellectual_curiosity thinking).each do |lense|
        find('#solution-head-input').trigger('click')
        fill_in 'solution-input', with: "test #{lense}"
        lense == 'thinking' ? click_on('Complete') : click_on('Continue')
      end

      expect(page).to have_content 'completed the workflow'
      click_on 'View feed'
      expect(page).to have_content 'global warming'
      expect(page).to have_content 'test thinking'
    end
  end
end
