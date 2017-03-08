require 'rails_helper'

feature 'Destroy Comment', js: true do
  background do
    @user = create(:user)
    @user2 = create(:user)
    @problem = create(:problem, user: @user)
    @comment = create(:comment, problem: @problem, user: @user2)
    login_as(@user2, scope: :user)
  end

  scenario 'destroy comment successfully' do
    visit problem_path(@problem.id)

    expect(page).to have_content 'Hello, this is awesome.'

    accept_confirm do
      find('.comment__delete-icon').trigger('click')
    end
    expect(page).to_not have_content 'Hello, this is awesome.'
  end
end
