require 'rails_helper'

RSpec.describe 'User edit', type: :feature do
  before do
    @user = User.create!(email: 'user@example.com', password: '12345678')
    @product = Product.create(name: 'product test', user: @user, status: 'published')
  end

  describe 'edit profile' do
    before do
      visit '/users/sign_in'
      fill_in('Email', with: 'user@example.com')
      fill_in('Password', with: '12345678')
      click_button('Log in')
      visit edit_user_registration_path(@user)
    end

    scenario 'change some information' do
      fill_in 'First name', with: 'new first name'
      fill_in 'First name', with: 'new last name'
      fill_in 'password', with: '87654321'
      fill_in 'Password confirmation', with: '87654321'
      fill_in 'Current password', with: '12345678'
      click_on 'Update'
    end
  end
end
