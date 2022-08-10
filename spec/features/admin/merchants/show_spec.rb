require 'rails_helper' 

RSpec.describe 'Admin Merchant Show Page' do 
    it 'has a form to update the Merchant inforation' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name)

        visit admin_merchant_path(merchant_1)

        click_link("Update Merchant Info")

        expect(current_path).to eq("/admin/merchants/#{merchant_1.id}/edit")
    end
end