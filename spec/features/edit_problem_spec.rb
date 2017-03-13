require 'rails_helper'

feature 'Edit Problem Spec', js: true do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
    @problem = create(:problem, user: @user)
  end

  context 'in review page' do
    scenario 'edits a problem' do
      visit review_problem_path(@problem)

      find('#edit-problem').trigger('click')
      fill_in 'problem[name]', with: 'Edited Problem Title'
      click_on 'Update'
      expect(page).to have_content 'Edited Problem Title'
    end
  end

  context 'in discussion page' do
    scenario 'edits a problem' do
      visit problem_path(@problem)
      find('.problem__btn--edit').click
      fill_in 'problem[name]', with: 'Edited Problem Title'
      click_on 'Update'
      expect(page).to have_content 'Edited Problem Title'
    end
  end

  context 'cannot edit other users problem' do
     background do
      @user_2 = create(:user)
      login_as(@user_2, scope: :user)
    end

    scenario 'try to edit problem and redirect to problems path' do
      visit edit_problem_path(@problem)
      expect(current_path).to eq '/problems'
      expect(page).to have_content 'My Feed'
    end

    scenario 'try to edit lense and redirect to problems path' do
      visit lenses_problem_path(@problem, 'thinking')
      expect(current_path).to eq '/problems'
      expect(page).to have_content 'My Feed'
    end

    scenario 'try to access review problem and redirect to problems path' do
      visit review_problem_path(@problem)
      expect(current_path).to eq '/problems'
      expect(page).to have_content 'My Feed'
    end
  end
end
