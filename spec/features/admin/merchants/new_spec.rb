require 'rails_helper' 

RSpec.describe 'form for new Merchant' do 
    it 'can create a new Merchant' do
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        
        merchant_3_name = Faker::Name.unique.name
        visit new_admin_merchant_path

        fill_in('New Merchant Name', with: merchant_3_name)
        click_on 'Create New Merchant'

        expect(current_path).to eq '/admin/merchants'
        
        within('#enabled') do 
            expect(page).to have_content merchant_1.name
            expect(page).to have_content merchant_2.name
        end

        within('#disabled') do 
            expect(page).to have_content merchant_3_name
        end
    end

    it 'goes back to form with error message if no name is submitted' do
        visit new_admin_merchant_path

        fill_in('New Merchant Name', with: "")
        click_on 'Create New Merchant'
        
        expect(page).to have_content 'Merchant not created: Please enter a name.'
    end
end