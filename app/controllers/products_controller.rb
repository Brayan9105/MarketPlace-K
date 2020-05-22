class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy propietary?]
  before_action :authenticate_user!, except: %i[index show]
  before_action :propietary?, only: %i[edit]

  def index
    @products = Product.published
  end

  def show
    can_open_product?(@product)
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
    if @product.save
      ProductMailer.product_published(@product).deliver! if @product.published?
      @product.save_categories
      flash[:notice] = 'Product was successfully created.'
      redirect_to @product
    else
      flash[:notice] = 'Error to created the product.'
      render :new
    end
  end

  def update
    if @product.update(product_params)
      @product.save_categories
      flash[:notice] = 'Product was successfully updated.'
      redirect_to @product
    else
      flash[:notice] = 'Error to edit the product.'
      render :edit
    end
  end

  def change_status
    Product.find(params[:id]).change_status
    redirect_back(fallback_location: root_path)
  end

  def delete_image
    product = Product.find(params[:id])
    product&.delete_image(params[:index].to_i)
    redirect_to product_path
  end

  def propietary?
    is_propietary!(@product)
  end

  private

  def can_open_product?(product)
    if user_signed_in?
      redirect_to products_path if (current_user.id != product.user.id) && !product.published?
    elsif !product.published?
      redirect_to products_path
    end
  end

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :quantity, :price, :status, images: [], category_elements: []).merge(user_id: current_user.id)
  end
end
