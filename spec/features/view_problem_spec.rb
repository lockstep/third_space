require 'rails_helper'

feature 'View Problem', js: true do
  background do
    @company = create(:company, name: 'Tesla', domain_name: '@tesla.com')
    @owner = create(:user, email: 'donale@tesla.com', company: @company)
    @problem = create(:problem, user: @owner)
  end

  context 'owner problem' do
    before { login_as(@owner, scope: :user) }
    scenario 'sees problem with edit/destroy/social media actions' do
      visit problem_path(@problem)
      expect(page).to have_css '.problem__btn--edit'
      expect(page).to have_css '.problem__btn--destroy'
      expect(page).to have_link 'Like'
      expect(page).to have_button 'Share'
    end

    context 'uncompleted problem' do
      scenario 'can continue to fill_in ACE-IT form' do
        @uncompleted_problem = Problem.create(name: 'Hello World', user: @owner)
        visit problem_path(@uncompleted_problem)

        expect(page).to have_content 'Continue'
        expect(page).to_not have_css '.problem__btn--edit'
        expect(page).to_not have_css '.problem__btn--destroy'
        expect(page).to_not have_link 'Like'
        expect(page).to_not have_button 'Share'
      end
    end
  end

  context 'another user' do
    context 'authenticated user' do
      context 'same domain name with owner problem' do
        before do
          another_user = create(:user, email: 'peter@tesla.com', company: @company)
          login_as(another_user, scope: :user)
        end

        scenario 'sees problem with some social media actions' do
          visit problem_path(@problem)

          expect(page).to have_content @problem.name.upcase
          expect(page).to_not have_css '.problem__btn--edit'
          expect(page).to_not have_css '.problem__btn--destroy'
          expect(page).to have_link 'Like'
          expect(page).to have_button 'Share'
        end
      end

      context 'different domain name with owner problem' do
        before do
          company = create(:company, name: 'Oracle', domain_name: '@oracle.com')
          another_user = create(:user, email: 'peter@oracle.com', company: company)
          login_as(another_user, scope: :user)
        end

        context 'problem is published' do
          before { @problem.update(public: true) }
          scenario 'sees problem with some social media actions' do
            visit problem_path(@problem)

            expect(page).to have_content @problem.name.upcase
            expect(page).to_not have_css '.problem__btn--edit'
            expect(page).to_not have_css '.problem__btn--destroy'
            expect(page).to have_link 'Like'
            expect(page).to have_button 'Share'
          end
        end

        context 'problem is not published' do
          scenario 'cannot see problem' do
            visit problem_path(@problem)
            expect(page).to_not have_content @problem.name.upcase
          end
        end
      end
    end

    context 'unauthenicated user' do
      context 'problem is published' do
        before { @problem.update(public: true) }
        scenario 'can see public problem' do
          visit problem_path(@problem)

          expect(page).to have_content @problem.name.upcase
          expect(page).to_not have_css '.problem__btn--edit'
          expect(page).to_not have_css '.problem__btn--destroy'
          expect(page).to_not have_link 'Like'
          expect(page).to have_button 'Share'

          expect(page).to have_link 'Sign In'
          expect(page).to have_link 'Create Account'

          expect(page).to_not have_content 'Feed'
          expect(page).to have_link 'ACE-IT'
          expect(page).to_not have_link 'Profile'
          expect(page).to_not have_link 'Logout'
        end

        context 'clicks on sign-in link' do
          before do
            @another_user = create(:user)
            visit problem_path(@problem)
            click_on 'Sign In'
          end

          scenario 'is brought to problem show path' do
            fill_in 'user[email]', with: @another_user.email
            fill_in 'user[password]', with: 'password'
            click_on 'Sign in'

            expect(page).to have_content @problem.name.upcase
            expect(current_url).to match "/problems/#{@problem.id}"
          end
        end

        context 'clicks on sign-up link' do
          before do
            visit problem_path(@problem)
            click_on 'Create Account'
          end

          scenario 'is brought to problem show path' do
            fill_in 'user[first_name]', with: 'peter'
            fill_in 'user[last_name]', with: 'thiel'
            fill_in 'user[email]', with: 'peter.thiel@gmail.com'
            fill_in 'user[password]', with: '123456'
            fill_in 'user[password_confirmation]', with: '123456'
            click_on 'Sign up'
            expect(page).to have_content @problem.name.upcase
            expect(current_url).to match "/problems/#{@problem.id}"
          end
        end
      end

      context 'problem is not published' do
        scenario 'cannot view unpublic problems' do
          visit problem_path(@problem)
          expect(page).to_not have_content @problem.name.upcase
        end
      end
    end
  end
end
