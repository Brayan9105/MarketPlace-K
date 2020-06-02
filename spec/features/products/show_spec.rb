require 'rails_helper'

RSpec.describe 'Show product', type: :feature do
  before do
    @user = User.create!(email: 'user@example.com', password: '12345678')
    @product = Product.create(name: 'product test', user: @user, status: 'published')
  end

  describe 'user without login or not product owner' do
    before(:each) do
      visit '/products/1'
    end

    scenario 'visit a published product' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('product test')
      expect(page).to have_content('user@example.com')
      expect(page).to have_content('published')
      expect(page).to have_no_content('Edit')
      expect(page).to have_no_content('Archive')
    end

    scenario 'click on email of the product owner ' do
      click_on('user@example.com')
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/user/1')
    end
  end

  describe 'product owner' do
    before(:each) do
      visit '/users/sign_in'
      expect(page).to have_http_status(200)
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      expect(page).to have_current_path('/')
      expect(page).to have_content('user@example.com')
      visit '/products/1'
    end

    scenario 'visit his own product' do
      expect(page).to have_http_status(200)
      expect(page).to have_content('product test')
      expect(page).to have_content('user@example.com')
      expect(page).to have_content('published')
      expect(page).to have_content('Edit')
      expect(page).to have_content('Archive')
    end

    scenario 'click on edit product' do
      click_on('Edit')
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/products/1/edit')
    end

    scenario 'click on archive' do
      click_on('Archive')
      expect(page).to have_http_status(200)
      expect(page).to have_current_path('/products/1')
    end
  end
end
