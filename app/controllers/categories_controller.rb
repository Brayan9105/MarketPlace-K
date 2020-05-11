class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products
  end

  def new
    @category = Category.new
    redirect_to categories_path
  end

  def edit
    redirect_to categories_path
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = 'Category was successfully created.'
      redirect_to @category
    else
      render :new
    end
  end

  def update
    if @category.update(category_params)
      flash[:notice] = 'Category was successfully updated.'
      redirect_to @category
    else
      render :edit
    end
  end

  def destroy
    @category.destroy
    flash[:notice] = 'Category was successfully destroyed.'
    redirect_to categories_url
  end

  private
    def set_category
      @category = Category.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name)
    end
end
