require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_presence_of(:discount) }
    it { should validate_numericality_of(:discount) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
  end

  describe ' instance methods' do
    it 'gives discounted revenue based on bulk discounts' do
      merchant = Merchant.create!(name: 'amazon')
      customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
      item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
      item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)
      invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)
      discount_1 = BulkDiscount.create!(quantity: 10, discount: 0.20, merchant_id: merchant.id)
      discount_2 = BulkDiscount.create!(quantity: 15, discount: 0.30, merchant_id: merchant.id)


      InvoiceItem.create!(quantity: 11, unit_price: 100, status: 'shipped', item: item_1, invoice: invoice_1)
      InvoiceItem.create!(quantity: 16, unit_price: 10, status: 'shipped', item: item_2, invoice: invoice_1)

      expect(invoice_1.discount_revenue).to eq(992)
    end
  end
end