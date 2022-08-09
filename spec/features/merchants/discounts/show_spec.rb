require 'rails_helper'

RSpec.describe 'Merchant Discounts show page' do
    it 'lists all discounts with with quantity threshold and discount' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)
        discount_2 = BulkDiscount.create!(quantity: 15, discount: 30, merchant_id: merchant_1.id)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}"

        within "#discount-details" do
            expect(page).to have_content("Threshold Quantity: 10")
            expect(page).to have_content("Discount: 20%")
            expect(page).to_not have_content("Threshold Quantity: 15")
        end
    end

    it 'has a link to edit discounts' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)
        discount_2 = BulkDiscount.create!(quantity: 15, discount: 30, merchant_id: merchant_1.id)

        visit "/merchants/#{merchant_1.id}/discounts/#{discount_1.id}"

        expect(page).to have_link("Edit Discount")
        click_on("Edit Discount")
        expect(current_path).to eq(edit_merchant_discount_path(merchant_1, discount_1))
    end
end