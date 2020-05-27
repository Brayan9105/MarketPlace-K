require 'rails_helper'

RSpec.describe 'Product index', type: :feature do
  before do
    @user = User.create!(email: 'user@example.com', password: '12345678')
    @product = Product.create(name: 'product test', user: @user, status: 'published')
  end

  describe 'when a user are not log in' do
    scenario 'click on create product' do
      visit '/products'
      expect(page).to have_content('Products')
      click_on 'Create product'
      expect(page).to have_current_path(new_user_session_path)
    end

    scenario 'click on product example' do
      visit '/products'
      expect(page).to have_content('product test')
      click_on 'product test'
      expect(page).to have_current_path(product_path(@product))
    end
  end#Describe

  describe 'when a user are log in' do
    scenario 'click on create product' do
      visit '/users/sign_in'
      expect(page).to have_http_status(200)
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      expect(page).to have_current_path('/')
      expect(page).to have_content('user@example.com')
      visit '/products'
      expect(page).to have_content('Products')
      click_on 'Create product'
      expect(page).to have_current_path(new_product_path)
    end

    scenario 'have product published' do
      visit '/users/sign_in'
      expect(page).to have_http_status(200)
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      expect(page).to have_current_path('/')
      expect(page).to have_content('user@example.com')
      visit '/products'
      expect(page).to have_content('Products')
      expect(page).to have_content('Edit')
      expect(page).to have_content('Archive')
    end

    scenario 'clicked on edit product' do
      visit '/users/sign_in'
      expect(page).to have_http_status(200)
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      expect(page).to have_current_path('/')
      expect(page).to have_content('user@example.com')
      visit '/products'
      expect(page).to have_content('Products')
      expect(page).to have_content('Edit')
      expect(page).to have_content('Archive')
      click_on('Edit')
      expect(page).to have_http_status(200)
      expect(page).to have_current_path(edit_product_path(@product))
    end

    scenario 'clicked on archive product' do
      visit '/users/sign_in'
      expect(page).to have_http_status(200)
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      expect(page).to have_current_path('/')
      expect(page).to have_content('user@example.com')
      visit '/products'
      expect(page).to have_content('Products')
      expect(page).to have_content('Edit')
      expect(page).to have_content('Archive')
      click_on('Archive')
      expect(page).to have_http_status(200)
    end
  end#Describe
end
