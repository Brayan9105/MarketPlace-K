class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @products = Product.published
  end

  def show
  end

  def new
    @product = Product.new
    @categories = Category.all
  end

  def edit
    @categories = Category.all
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        @product.save_categories
        # [:notice] = 'Product was successfully created.'
        redirect_to @product

      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        @product.save_categories
        format.html { redirect_to @product, notice: 'Product was successfully updated.' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_status
    Product.find(params[:id]).change_status
    redirect_to user_path(current_user)
  end

  def delete_image
    product = Product.find(params[:id])
    product.delete_image(params[:index].to_i) if product
    redirect_to product_path
  end

  private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :quantity, :price, :status, images: [], category_elements: []).merge(user_id: current_user.id)
    end
end
