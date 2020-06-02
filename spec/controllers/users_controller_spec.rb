require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe 'actions' do
    describe 'index' do
      context 'get index' do
        it 'return a 200 status' do
          get :index
          expect(response).to have_http_status(200)
        end

        it 'return an array of users' do
          user = User.create(email: 'test@test.com', password: '12345678')
          get :index
          expect(assigns(:users)).to eq([user])
        end
      end
    end#index

    describe 'show' do
      context 'get show' do
        before(:each) do
          user = User.create(email: 'test@test.com', password: '12345678')
        end

        it 'return a 200 status' do
          get :show, params: {id: '1'}
          expect(response).to have_http_status(200)
        end

        it 'return an array of users' do
          get :show, params: {id: 1}
          expect(response).to render_template("show")
        end
      end
    end#show
  end
end
