require 'rails_helper'

RSpec.describe 'Edit product', type: :feature do
  before do
    Status.create(name: 'published')
    Status.create(name: 'archived')
    @user = User.create!(email: 'user@example.com', password: '12345678')
    @product = Product.create(name: 'product test', user: @user, status: 'published')
  end

  describe 'login user try to his edit a product' do
    scenario 'update product information' do
      visit '/users/sign_in'
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      visit '/products/1/edit'

      fill_in('Name', with: 'Change product')
      fill_in('Quantity', with: 10)
      fill_in('Price', with: 1000)
      select('published', from: 'Status')
      click_on('Update Product')

      expect(page).to have_http_status(200)
      expect(page).to have_content('Change product')
      expect(page).to have_content('10')
      expect(page).to have_content('1000')
      expect(page).to have_content('published')
    end
  end
end
