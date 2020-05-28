require 'rails_helper'

RSpec.describe 'User index', type: :feature do
  before do
    @user = User.create!(email: 'user@example.com', password: '12345678')
    @product = Product.create(name: 'product test', user: @user, status: 'published')
  end

  describe 'user without login' do
    before(:each) do
      visit '/users'
    end

    scenario 'visit user index' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('Users')
      expect(page).to have_content('1 User')
      expect(page).to have_content('Sign up')
      expect(page).to have_content('Log in')
      expect(page).to have_content('user@example.com')
      expect(page).to have_content('view profile')
    end

    scenario 'click on user email' do
      click_on('user@example.com')
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/user/1')
    end

    scenario 'click on sign up button' do
      find("a[data-signup='button']").click
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/users/sign_up')
    end

    scenario 'click on log in button' do
      find("a[data-login='button']").click
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/users/sign_in')
    end
  end

  describe 'loged user' do
    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      visit '/users'
    end

    scenario 'visit user index' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('Users')
      expect(page).to have_content('1 User')
      expect(page).to have_no_content('Sign up')
      expect(page).to have_no_content('Log in')
      expect(page).to have_content('user@example.com')
      expect(page).to have_content('view profile')
    end

    scenario 'click on user email' do
      click_on('user@example.com')
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/user/1')
    end
  end
end
