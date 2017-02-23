require 'rails_helper'

feature 'Edit Problem Spec' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
    @problem = create(:problem, user: @user)
  end

  scenario 'edits a problem ', js: true do
    visit success_problem_path(@problem)

    expect(page).to have_content(@problem.name)
    find('#edit-problem').trigger('click')

    fill_in 'new-problem-input', with: 'Edited Problem Title'
    click_on 'Update'

    expect(page).to have_content 'Edited Problem Title'
  end

  scenario 'edits a 360 degree thinking ', js: true do
    visit "/problems/#{@problem.id}/success"

    expect(page).to have_content(@problem.name)
    find('#edit-thinking').trigger('click')

    find('#solution-head-input').trigger('click')
    fill_in 'solution-input', with: "This is awesome solution"
    click_on('Complete')

    expect(page).to have_content 'This is awesome solution'
  end

end
