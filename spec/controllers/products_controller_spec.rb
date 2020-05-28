require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "actions" do
    before(:each) do
      @user = User.create(email: 'test@test.com', password: '12345678')
    end

    describe 'product mailer' do
      before(:each) do
        sign_in @user
      end

      context 'when a product is created with published status' do
        it "returns a deliveries count 1" do
          post :create, params: {product: {name: 'product test', status: 'published'}}
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end

      context 'when a product is created with a status different to published' do
        it "returns a deliveries count 0" do
          post :create, params: {product: {name: 'product test', status: 'unpublished'}}
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end

        it "returns a deliveries count 0" do
          post :create, params: {product: {name: 'product test', status: 'archived'}}
          expect(ActionMailer::Base.deliveries.count).to eq(0)
        end
      end

      context 'when a product change it status to published' do
        it "returns a deliveries count 1" do
          @product = Product.create(name: 'product test', user: @user, status: 'unpublished')

          get :change_status, params: {id: @product.id}
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end

        it "returns a deliveries count 1" do
          @product = Product.create(name: 'product test', user: @user, status: 'archived')

          get :change_status, params: {id: @product.id}
          expect(ActionMailer::Base.deliveries.count).to eq(1)
        end
      end
    end#Mail

    describe 'get index' do
      it 'dont assigns to @products' do
        product = Product.create(name: 'product test', user: @user, status: 'archived')
        get :index
        expect(assigns(:products)).to eq([])
      end

      it 'assigns to @products' do
        product = Product.create(name: 'product test', user: @user, status: 'published')
        get :index
        expect(assigns(:products)).to eq([product])
      end

      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end
    end#index

    describe 'get show' do
      it 'return a ok status' do
        product = Product.create(name: 'product test', user: @user, status: 'published')
        get :show, params: {id: 1}
        expect(response).to have_http_status(:ok)
      end

      it "renders the index template" do
        product = Product.create(name: 'product test', user: @user, status: 'published')
        get :show, params: {id: 1}
        expect(response).to render_template("show")
      end
    end#show

    describe 'get new' do
      before(:each) do
        sign_in @user
      end

      it 'return a ok status' do
        get :new
        expect(response).to have_http_status(:ok)
      end

      it "renders the index template" do
        get :new
        expect(response).to render_template("new")
      end
    end#new

    describe 'get edit' do
      before(:each) do
        product = Product.create(name: 'product test', user: @user, status: 'published')
      end

      it 'return a 302 status and redirect to show product' do
        get :edit, params: {id: 1}
        expect(response).to have_http_status(302)
      end

      it 'return a ok status' do
        sign_in @user
        get :edit, params: {id: 1}
        expect(response).to have_http_status(:ok)
      end

      it "renders the index template" do
        sign_in @user
        get :edit, params: {id: 1}
        expect(response).to render_template("edit")
      end
    end#show

    describe 'post create' do
      before(:each) do
        sign_in @user
      end

      it 'redirect to the product created' do
        post :create, params: {product: {name: 'product test', status: 'published'}}
        expect(response).to redirect_to(Product.last)
      end

      it 'render new again' do
        post :create, params: {product: {name: 'pro', status: 'published'}}
        expect(response).to render_template(:new)
      end

      it 'render new again' do
        post :create, params: {product: {status: 'published'}}
        expect(response).to render_template(:new)
      end
    end#create

    describe 'put update' do
      before(:each) do
        sign_in @user
      end

      it 'redirect to the product updated' do
        product = Product.create(name: 'product test', user: @user, status: 'published')
        put :update, params:{product: {name: 'Other name', status: 'published'}, id: product.id}
        expect(response).to redirect_to(Product.last)
      end

      it 'render edit again' do
        product = Product.create(name: 'product test', user: @user, status: 'published')
        put :update, params:{product: {name: 'Som', status: 'published'}, id: product.id}
        expect(response).to render_template(:edit)
      end
    end#update
  end
end
