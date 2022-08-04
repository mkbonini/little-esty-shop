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
end