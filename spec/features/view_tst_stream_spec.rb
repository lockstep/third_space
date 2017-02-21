require 'rails_helper'

feature 'View TST Stream' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  context 'TST stream' do
    background do
      create(:problem, name: 'my problem', user: @user, created_at: Date.parse('/06/08/2015'))
      create(:problem, name: 'my problem 2', user: @user, created_at: Date.parse('/07/08/2015'))
      create(:problem, name: "Somebody else's problem", user: create(:user), created_at: Date.parse('/08/08/2015'))
      create(:problem, name: "Somebody else's problem 2", user: create(:user), created_at: Date.parse('/09/08/2015'))
    end

    context 'My problem' do
      scenario 'displays my problems' do
        visit problems_path
        click_link 'My'
        expect(page).to have_content 'my problem'
        expect(page).to have_content 'my problem 2'
        expect(page).to_not have_content "Somebody else's problem"
        expect(page).to_not have_content "Somebody else's problem 2"
      end

      scenario 'displays latest problems first' do
        visit problems_path
        click_link 'My'
        expect(all('.problem__title')[0].text).to eq 'my problem 2'
        expect(all('.problem__title')[1].text).to eq 'my problem'
      end
    end

    context 'All problem' do
      scenario 'views all problems' do
        visit problems_path
        click_link 'All'
        expect(page).to have_content 'my problem'
        expect(page).to have_content 'my problem 2'
        expect(page).to have_content "Somebody else's problem"
        expect(page).to have_content "Somebody else's problem 2"
      end

      scenario 'displays latest problems first' do
        visit problems_path
        click_link 'All'
        expect(all('.problem__title')[0].text).to eq "Somebody else's problem 2"
        expect(all('.problem__title')[1].text).to eq "Somebody else's problem"
        expect(all('.problem__title')[2].text).to eq 'my problem 2'
        expect(all('.problem__title')[3].text).to eq 'my problem'
      end
    end
  end

  scenario 'renders pagination correctly' do
    create_list(:problem, 31, user: @user)
    Problem.first.update(name: 'first problem')
    visit problems_path
    click_link 'My'
    expect(page).to have_content('My Problem 31')
    expect(page).not_to have_content('first problem')
    click_on '2'
    expect(page).to have_content('first problem')
    expect(page).to_not have_content('My Problem 31')
  end
end
