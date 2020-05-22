require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "actions" do
    describe 'product mailer' do
      before do
        @user = User.create(email: 'test@test.com', password: '12345678')
      end

      context 'when a product is created with published status' do
        it "returns a deliveries count 1" do
          sign_in @user
          post :create, params: {product: {name: 'product test', status: 'published'}}
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end

      context 'when a product is created with a status different to published' do
        it "returns a deliveries count 0" do
          sign_in @user
          post :create, params: {product: {name: 'product test', status: 'unpublished'}}
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end

        it "returns a deliveries count 0" do
          sign_in @user
          post :create, params: {product: {name: 'product test', status: 'archived'}}
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end

      context 'when a product change it status to published' do
        it "returns a deliveries count 1" do
          @product = Product.create(name: 'product test', user: @user, status: 'unpublished')

          sign_in @user
          get :change_status, params: {id: @product.id}
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end

        it "returns a deliveries count 1" do
          @product = Product.create(name: 'product test', user: @user, status: 'archived')

          sign_in @user
          get :change_status, params: {id: @product.id}
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end
    end#Mail
  end
end
