require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'Validations' do
    let(:user) {User.create(email: 'test@test.com', password: '12345678')}

    describe 'name' do
      context 'when it is empty' do
        it 'is not valid' do
          expect(Product.new(user: user).valid?).to be_falsey
        end
      end

      context 'when it is present' do
        it 'is valid' do
          expect(Product.new(name: 'product test', user: user).valid?).to be_truthy
        end
      end
    end#Name

    describe 'images' do
      let(:product) { Product.create(name: 'test product', user: user) }

      before do
        product.images = nil
      end

      context 'when attach file is not jpg or png' do
        it 'adds an error to product' do
          product.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "img.GIF")), filename: 'image.GIF')
          expect(product.errors[:images].count).to eq(1)
        end
      end

      context 'when attach file is a jpg' do
        it 'doesnt add an error' do
          product.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "img.JPG")), filename: 'img.JPG')
          expect(product.errors[:images].count).to eq(0)
        end
      end

      context 'when attach file is png' do
        it 'doesnt add an error' do
          product.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "img.PNG")), filename: 'img.PNG')
          expect(product.errors[:images].count).to eq(0)
        end
      end

      context 'when delete a images attached' do
        it 'delete the corresponding image' do
          product.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "img.PNG")), filename: 'img.PNG')
          product.images.attach(io: File.open(Rails.root.join("spec", "fixtures", "img.JPG")), filename: 'img.JPG')

          product.delete_image(1)
          expect(product.images.count).to eq(1)

        end
      end
    end#Images

    describe 'categories' do
      let(:product) { Product.create(name: 'test product', user: user) }
      let(:category) { Category.create(name: 'test category') }

      context 'when categories are not selected' do
        it 'should not have any categories' do
          expect(product.categories.count).to eq(0)
        end
      end

      context 'when some categories are selected' do
        it 'should have some categories' do
          Productxcategory.create(product: product, category: category)
          expect(product.categories.count).to eq(1)
        end
      end
    end#Categories

    describe 'status' do
      let(:product) { Product.create(name: 'test product', user: user) }

      context 'when the status is changed in the user profile' do
        it 'changes from unpublished to published status' do
          product.status = 'unpublished'
          product.change_status
          expect(product.status).to eq('published')
        end

        it 'changes from archived to published status' do
          product.status = 'archived'
          product.change_status
          expect(product.status).to eq('published')
        end

        it 'changes to archived status' do
          product.status = 'published'
          product.change_status
          expect(product.status).to eq('archived')
        end
      end
    end#Status
  end#validations
end
