require 'rails_helper'

feature 'Edit Comment', js: true do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
    @comment = create(:comment, problem: @problem, user: @user2)
    login_as(@user2, scope: :user)
  end

  scenario 'edit the comment successfully' do
    visit problem_path(@problem.id)

    expect(page).to have_content 'Hello, this is awesome.'

    find('.comment__edit-icon').trigger('click')
    expect(page).to have_content "Edit Comment"
    fill_in 'edit-comment-input', with: 'Edited comment'
    click_on 'Edit'

    expect(page).to_not have_content 'Hello, this is awesome.'
    expect(page).to have_content 'Edited comment'
  end
end
