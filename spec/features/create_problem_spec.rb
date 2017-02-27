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
      fill_in 'problem[name]', with: 'global warming'
      click_on 'Next'

      %w(adaptability cultural_competence empathy intellectual_curiosity thinking).each do |lense|
        find('#solution-head-input').trigger('click')
        expect(find('.lense__btn--submit')['disabled']).to eq true
        fill_in 'solution-input', with: "test #{lense}"
        lense == 'thinking' ? click_on('Complete') : click_on('Continue')
      end

      expect(page).to have_content 'completed the workflow'
      click_on 'View Feed'
      expect(page).to have_content 'GLOBAL WARMING'
      expect(page).to have_content 'test thinking'
    end

    scenario 'cannot post the problem' do
      fill_in 'problem[name]', with: ''
      expect(find('.problem__btn--submit')['disabled']).to eq true
    end
  end
end
