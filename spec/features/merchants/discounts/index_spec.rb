require 'rails_helper'

RSpec.describe 'Merchant Discounts Index page' do
    it 'lists all discounts with with quantity threshold and discount' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        merchant_2 = Merchant.create!(name: 'Mike Bonini')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)
        discount_2 = BulkDiscount.create!(quantity: 15, discount: 30, merchant_id: merchant_1.id)
        discount_3 = BulkDiscount.create!(quantity: 20, discount: 40, merchant_id: merchant_2.id)

        visit "/merchants/#{merchant_1.id}/discounts"

        within "#discount-list" do
            expect(page).to have_link("Threshold Quantity: 10, Discount: 20%")
            expect(page).to have_link("Threshold Quantity: 15, Discount: 30%")
            expect(page).to_not have_content("Threshold Quantity: 20, Discount: 40%")
        end
    end

    it 'each discount links to discount show page' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)

        visit "/merchants/#{merchant_1.id}/discounts"
        click_on("Threshold Quantity: 10, Discount: 20%")

        expect(current_path).to eq(merchant_discount_path(merchant_1, discount_1))
    end
end