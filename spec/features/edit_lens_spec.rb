require 'rails_helper'

feature 'Edit Lens Spec', js: true do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
    @problem = create(:problem, user: @user)
  end

  context 'in review page' do
    scenario 'edits 360 degree thinking' do
      visit review_problem_path(@problem)

      find('#edit-thinking').trigger('click')
      find('#solution-head-input').trigger('click')
      fill_in 'solution-input', with: "This is awesome solution"
      click_on('Complete')
      expect(page).to have_content 'This is awesome solution'
    end
  end
end
