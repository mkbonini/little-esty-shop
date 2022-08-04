require 'rails_helper'

RSpec.describe 'Merchant Discounts Create' do
    it 'can create and item' do
        merchant = Merchant.create!(name: Faker::Company.name)

        visit "/merchants/#{merchant.id}/discounts/new"

        fill_in :quantity, with: "10"
        fill_in :discount, with: "50"

        click_button 'Create Bulk Discount'

        expect(current_path).to eq(merchant_discounts_path(merchant))

        within "#discount-list" do
            expect(page).to have_link("Threshold Quantity: 10, Discount: 50%")
        end
    end

    it 'goes back to form with an error message if not all fields are filled' do
        merchant = Merchant.create!(name: Faker::Company.name)
        visit new_merchant_discount_path(merchant)

        fill_in :quantity, with: "10"

        click_button 'Create Bulk Discount'

        expect(current_path).to eq(new_merchant_discount_path(merchant))
    
        expect(page).to have_content 'Error: Please fill in all fields.'
      end
end