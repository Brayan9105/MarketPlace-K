class ProductMailer < ApplicationMailer
  def product_published(product)
    @product = product
    mails = User.pluck(:email).join(';')
    mail(to: mails, subject: 'A new product have been published')
  end
end
