require "rails_helper"

RSpec.describe ProductMailer, type: :mailer do
  describe "mail" do
    let(:user) {User.create(email: 'test@test.com', password: '12345678')}
    let(:product) {Product.create(name: 'product test', user: user)}
    let(:mail) { ProductMailer.product_published(product).deliver }

    context "When a product is published" do
      it "renders the headers" do
        expect(mail.subject).to eq("A new product have been published")
        expect(mail.to).to eq(["test@test.com"])
        expect(mail.from).to eq(["brayanlopez9105@gmail.com"])
      end
    end
  end
end
