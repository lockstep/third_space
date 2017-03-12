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

      %w(adaptability cultural_competency empathy intellectual_curiosity thinking).each do |lens|
        find('#solution-head-input').trigger('click')
        expect(find('.lens__btn--submit')['disabled']).to eq true
        fill_in 'solution-input', with: "test #{lens}"
        lens == 'thinking' ? click_on('Complete') : click_on('Continue')
      end

      expect(page).to have_content 'Review'
      expect(page).to have_content 'global warming'
      expect(page).to have_content 'test thinking'
      expect(page).to have_link 'View Feed'
      expect(page).to have_link 'New Problem'
      expect(page).to have_link 'Add Comment'
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

      click_on 'C'
      expect(page).to have_content 'Adaptability'
    end

    scenario 'can navigate to only lens that have value' do
      visit new_problem_path
      fill_in 'problem[name]', with: 'Hello'
      click_on 'Next'

      %w(adaptability cultural_competency empathy ).each do |lens|
        find('#solution-head-input').trigger('click')
        expect(find('.lens__btn--submit')['disabled']).to eq true
        fill_in 'solution-input', with: "test #{lens}"
        click_on 'Continue'
      end

      click_on 'C'
      expect(page).to have_content 'Cultural'

      click_on 'T'
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
