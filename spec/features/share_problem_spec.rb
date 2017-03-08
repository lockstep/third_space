require 'rails_helper'

feature 'Share Problem', js: true do
  background do
    @user = create(:user)
    @problem = create(:problem, user: @user)
    login_as(@user, scope: :user)
  end

  scenario 'shares via facebook' do
    visit problem_path(@problem.id)
    click_on 'Share'
    expect(page).to have_content 'Share Problem'
    new_window = window_opened_by { find('.btn--facebook').trigger('click') }
    expect(new_window).to_not be_nil
  end

  scenario 'shares via twitter' do
    visit problem_path(@problem.id)
    click_on 'Share'
    expect(page).to have_content 'Share Problem'
    new_window = window_opened_by { find('.btn--twitter').trigger('click') }
    expect(new_window).to_not be_nil
  end
end
