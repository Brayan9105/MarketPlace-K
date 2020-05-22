require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    describe 'email' do
      context 'when it is empty' do
        it 'is not valid' do
          expect(User.new(password: '12345678').valid?).to be_falsey
        end
      end

      context 'when it is present' do
        it 'is valid' do
          expect(User.new(email: 'test@test.com', password: '12345678').valid?).to be_truthy
        end
      end
    end#email

    describe 'password' do
      context 'when it is empty' do
        it 'is not valid' do
          expect(User.new(email: 'test@test.com').valid?).to be_falsey
        end
      end

      context 'when it is present' do
        it 'is valid' do
          expect(User.new(email: 'test@test.com', password: '12345678').valid?).to be_truthy
        end
      end

      context 'when it is to short' do
        it 'is not valid' do
          expect(User.new(email: 'test@test.com', password: '1234').valid?).to be_falsey
        end
      end
    end#Password
  end
end
