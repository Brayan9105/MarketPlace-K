require "rails_helper"

RSpec.describe ProductMailer, type: :mailer do
  describe "mail" do
    before do
      @user = User.create(email: 'test@test.com', password: '12345678')
      @product = Product.create(name: 'product test', user: @user)
      @mail = ProductMailer.product_published(@product).deliver
    end

    context "When a product is published" do
      it "renders the headers" do
        expect(@mail.subject).to eq("A new product have been published")
        expect(@mail.to).to eq(["test@test.com"])
        expect(@mail.from).to eq(["brayanlopez9105@gmail.com"])

        expect(ActionMailer::Base.deliveries.count).to eq(1)
      end
    end
  end
end
