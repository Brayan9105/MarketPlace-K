ActiveAdmin.register Product do
  permit_params :name, :description, :quantity, :price, :status, :user_id

  scope :all
  scope :published
  scope :unpublished
  scope :archived

  action_item :publish, only: :show do
    link_to 'Publish', publish_admin_product_path(product), method: :put if product.status != 'published'
  end

  action_item :archive, only: :show do
    link_to 'Archive', archive_admin_product_path(product), method: :put if product.status == 'published'
  end

  member_action :publish, method: :put do
    product = Product.find(params[:id])
    product.update(status: 'published')
    redirect_to admin_product_path(product)
  end

  member_action :archive, method: :put do
    product = Product.find(params[:id])
    product.update(status: 'archived')
    redirect_to admin_product_path(product)
  end

end
