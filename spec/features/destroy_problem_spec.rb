require 'rails_helper'

feature 'Destroy Problem Spec', js: true do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
    @problem = create(:problem, user: @user)
  end

  scenario 'deletes problem' do
    visit problem_path(@problem)

    accept_confirm do
      find('.problem__btn--destroy').click
    end
    expect(page).to have_content 'My Feed'
  end
end
