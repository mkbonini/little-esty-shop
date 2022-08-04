require 'rails_helper'

RSpec.describe 'Merchant Discounts Index page' do
    it 'lists all discounts with with quantity threshold and discount' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        merchant_2 = Merchant.create!(name: 'Mike Bonini')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)
        discount_2 = BulkDiscount.create!(quantity: 15, discount: 30, merchant_id: merchant_1.id)
        discount_3 = BulkDiscount.create!(quantity: 20, discount: 40, merchant_id: merchant_2.id)

        visit "/merchants/#{merchant_1.id}/discounts"

        within "#disocunt-list" do
            expect(page).to have_link("Threshold Quantity: 10, Discount: 20%")
            expect(page).to have_link("Threshold Quantity: 15, Discount: 30%")
            expect(page).to_not have_content("Threshold Quantity: 20, Discount: 40%")
        end
    end
end