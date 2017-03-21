require 'rails_helper'

feature 'Create Problem Spec' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  context 'creates a problem', js: true do
    scenario 'creates a problem successfull' do
      visit new_problem_path
      fill_in 'problem[name]', with: 'global warming'
      click_on 'Next'

      %w(adaptability cultural_competency empathy intellectual_curiosity thinking).each do |lense|
        sleep(1)
        expect(find('.lens__btn--submit')['disabled']).to eq true
        fill_in 'solution-input', with: "test #{lense}"
        find('#next-bar').trigger('click')
      end
      expect(page).to have_content 'Review'
      expect(page).to have_content 'global warming'
      expect(page).to have_content 'test thinking'
      expect(page).to have_link 'View Feed'
    end

    scenario 'cannot post the problem' do
      visit new_problem_path
      fill_in 'problem[name]', with: ''
      expect(find('.problem__btn--submit')['disabled']).to eq true
    end

    scenario 'cannot navigate to lens that do not have value' do
      visit new_problem_path
      fill_in 'problem[name]', with: 'global warming'
      click_on 'Next'

      expect(page).to have_content 'Adaptability'

      find('.ace-it__button', text: 'C').trigger('click')
      expect(page).to have_content 'Adaptability'
    end

    scenario 'can navigate to only lens that have value' do
      visit new_problem_path
      fill_in 'problem[name]', with: 'Hello'
      click_on 'Next'

      %w(adaptability cultural_competency empathy ).each do |lense|
        fill_in 'solution-input', with: "test #{lense}"
        find('#next-bar').trigger('click')
      end

      find('.ace-it__button', text: 'C').trigger('click')
      expect(page).to have_content 'Cultural'

      find('.ace-it__button', text: 'T').trigger('click')
      expect(page).to have_content 'Cultural'
    end

    context 'user does not finish ACE-IT form' do
      scenario 'can comeback to update ACE-IT' do
        visit new_problem_path
        fill_in 'problem[name]', with: 'global warming'
        click_on 'Next'
        find('#solution-head-input').trigger('click')
        fill_in 'solution-input', with: "test adaptability"
        click_on('Continue')
        click_on('Feed')
        click_on('Create New')
        expect(page).to have_content 'Cultural Competency'
        expect(page).to have_content 'What is your solution through this lens?'
      end
    end
  end
end
