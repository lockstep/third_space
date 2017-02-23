require 'rails_helper'

feature 'View TST Stream' do
  background do
    @user = create(:user)
    login_as(@user, scope: :user)
  end

  context 'TST stream' do
    background do
      microsoft = create(:company, name: 'microsoft', domain_name: 'microsoft.com')
      @user.company = microsoft
      create(:problem, name: 'my problem', user: @user, created_at: Date.parse('/06/08/2015'))
      create(:problem, name: 'my problem 2', user: @user, created_at: Date.parse('/07/08/2015'))

      user2 = create(:user, first_name: 'bill', last_name: 'gate', company: microsoft)
      create(:problem, name: "Somebody else's problem", user: user2, created_at: Date.parse('/08/08/2015'))

      oracle = create(:company, name: 'oracle', domain_name: 'oracle.com')
      user3 = create(:user, first_name: 'larry', last_name: 'ellison', company: oracle)
      create(:problem, name: "Somebody else's problem 2", user: user3, created_at: Date.parse('/09/08/2015'))
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
      scenario 'displays only problems in company' do
        visit problems_path
        click_link 'All'
        expect(page).to have_content 'my problem'
        expect(page).to have_content 'my problem 2'
        expect(page).to have_content "Somebody else's problem"
        expect(page).to_not have_content "Somebody else's problem 2"
      end

      scenario 'displays latest problems first' do
        visit problems_path
        click_link 'All'
        expect(all('.problem__title')[0].text).to eq "Somebody else's problem"
        expect(all('.problem__title')[1].text).to eq 'my problem 2'
        expect(all('.problem__title')[2].text).to eq 'my problem'
      end

      context 'user does not have company' do
        scenario 'displays my problems' do
          @user.update(company: nil)
          visit problems_path
          click_link 'All'
          expect(page).to have_content 'my problem'
          expect(page).to have_content 'my problem 2'
          expect(page).to_not have_content "Somebody else's problem"
          expect(page).to_not have_content "Somebody else's problem 2"
        end
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
