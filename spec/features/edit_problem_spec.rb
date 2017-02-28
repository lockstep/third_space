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
      expect(page).to have_content 'Successfully updated problem'
    end
  end

  context 'in discussion page' do
    scenario 'edits a problem' do
      visit problem_path(@problem)
      click_link 'Edit'

      fill_in 'problem[name]', with: 'Edited Problem Title'
      click_on 'Update'
      expect(page).to have_content 'Successfully updated problem'
    end
  end
end
