require 'rails_helper'

RSpec.describe 'User show', type: :feature do
  before do
    @user = User.create!(email: 'user@example.com', password: '12345678')
    @product = Product.create(name: 'product test', user: @user, status: 'published')
  end

  describe 'strage user' do
    before(:each) do
      visit 'user/1'
    end

    scenario 'visit user profile' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('user@example.com')
      expect(page).to have_no_content('Edit profile')
      expect(page).to have_content('product test')
      expect(page).to have_no_content('Edit')
      expect(page).to have_no_content('Archive')
    end

    scenario 'click on create product' do
      click_on 'Create product'
      expect(page).to have_current_path('/users/sign_in')
    end

    scenario 'click on product name' do
      click_on 'product test'
      expect(page).to have_http_status(200)
    end
  end

  describe 'loged user' do
    before(:each) do
      visit '/users/sign_in'
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      visit '/user/1'
    end

    scenario 'visit his own profile' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('user@example.com')
      expect(page).to have_content('Edit profile')
      expect(page).to have_content('product test')
      expect(page).to have_content('Edit')
      expect(page).to have_content('Archive')
    end

    scenario 'click on edit profile' do
      click_on 'Edit profile'
      expect(page).to have_http_status(200)
    end

    scenario 'click on product name' do
      click_on 'product test'
      expect(page).to have_http_status(200)
    end

    scenario 'click on create product' do
      click_on 'Create product'
      expect(page).to have_http_status(200)
    end
  end
end
