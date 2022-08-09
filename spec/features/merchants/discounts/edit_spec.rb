require 'rails_helper'

RSpec.describe 'merchant discount edit page' do
    it 'will display current info in a form' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 0.20, merchant_id: merchant_1.id)

        visit edit_merchant_discount_path(merchant_1, discount_1)

        expect(page).to have_field(:quantity, with: 10)
        expect(page).to have_field(:discount, with: 0.20)
    end

    it 'updates details in correctly filled in forms' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)

        visit edit_merchant_discount_path(merchant_1, discount_1)

        fill_in :quantity, with: 20
        fill_in :discount, with: 0.40

        click_on 'Update Discount'

        expect(current_path).to eq(merchant_discount_path(merchant_1, discount_1))

        within "#discount-details" do
            expect(page).to have_content("Threshold Quantity: 20")
            expect(page).to have_content("Discount: 40%")
            expect(page).to_not have_content("Threshold Quantity: 10")
        end
    end

    it 'redirects back to edit if not all fields are filled in' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)

        visit edit_merchant_discount_path(merchant_1, discount_1)

        fill_in :quantity, with: 20
        fill_in :discount, with: ""

        click_on 'Update Discount'

        expect(current_path).to eq(edit_merchant_discount_path(merchant_1, discount_1))
        expect(page).to have_content('Error: Please fill in all fields.')
    end

end