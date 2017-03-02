require 'rails_helper'

feature 'Create Problem Spec' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  context 'creates a problem', js: true do
    background { visit new_problem_path }

    scenario 'creates a problem successfull' do
      fill_in 'problem[name]', with: 'global warming'
      click_on 'Next'

      %w(adaptability cultural_competence empathy intellectual_curiosity thinking).each do |lense|
        find('#solution-head-input').trigger('click')
        expect(find('.lense__btn--submit')['disabled']).to eq true
        fill_in 'solution-input', with: "test #{lense}"
        lense == 'thinking' ? click_on('Complete') : click_on('Continue')
      end

      expect(page).to have_content 'Review'
      expect(page).to have_content 'global warming'
      expect(page).to have_content 'test thinking'
      expect(page).to have_link 'View Feed'
      expect(page).to have_link 'New Problem'
      expect(page).to have_link 'Add Comment'
    end

    scenario 'cannot post the problem' do
      fill_in 'problem[name]', with: ''
      expect(find('.problem__btn--submit')['disabled']).to eq true
    end

    scenario 'cannot navigate to lense that do not have value' do
      fill_in 'problem[name]', with: 'global warming'
      click_on 'Next'

      expect(page).to have_content 'Adaptability'

      click_on 'C'
      expect(page).to have_content 'Adaptability'
    end

    scenario 'can navigate to only lense that have value' do
      fill_in 'problem[name]', with: 'Hello'
      click_on 'Next'

      %w(adaptability cultural_competence empathy ).each do |lense|
        find('#solution-head-input').trigger('click')
        expect(find('.lense__btn--submit')['disabled']).to eq true
        fill_in 'solution-input', with: "test #{lense}"
        click_on 'Continue'
      end

      click_on 'C'
      expect(page).to have_content 'Cultural'

      click_on 'T'
      expect(page).to have_content 'Cultural'
    end
  end
end
