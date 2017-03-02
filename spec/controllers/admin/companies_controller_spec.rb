require 'rails_helper'

describe Admin::CompaniesController do
  login_admin

  describe 'POST create' do
    before do
      @user2 = create(:user, email: 'hello@google.com')
      @user3 = create(:user, email: 'peter@google.com')
      @user4 = create(:user, email: 'eric@facebook.com')
      post :create, params: { company: { name: 'google', domain_name: 'google.com' } }
    end

    it 'creates a company' do
      expect(Company.count).to eq 1
      company = Company.first
      expect(company.name).to eq 'google'
      expect(company.domain_name).to eq 'google.com'
    end

    it 'participates with users' do
      expect(@user2.reload.company).to eq Company.first
      expect(@user3.reload.company).to eq Company.first
      expect(@user4.reload.company).to eq nil
    end
  end
end
