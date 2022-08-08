require 'rails_helper'

RSpec.describe 'merchant discount edit page' do
    it 'will display current info in a form' do
        merchant_1 = Merchant.create!(name: 'Mike Dao')
        discount_1 = BulkDiscount.create!(quantity: 10, discount: 20, merchant_id: merchant_1.id)

        visit edit_merchant_discount_path(merchant_1, discount_1)

        expect(page).to have_field(:quantity, with: 10)
        expect(page).to have_field(:discount, with: 20)
    end
end