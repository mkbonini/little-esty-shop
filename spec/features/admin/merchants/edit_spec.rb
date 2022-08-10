require 'rails_helper'

RSpec.describe 'Admin Merchants Edit page' do 
    it 'has a fillable form that redirects me to the Admin Merchants Show page with the updated information' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name)

        visit admin_merchant_path(merchant_1)

        expect(page).to have_content(merchant_1.name)

        click_link("Update Merchant Info")

        old_name = merchant_1.name 
        new_name = Faker::Name.unique.name

        expect(current_path).to eq "/admin/merchants/#{merchant_1.id}/edit"
        expect(page).to have_field('Updated Merchant Name', with: old_name)

        fill_in "Name", with: new_name 
        click_on("Update Information")

        expect(current_path).to eq "/admin/merchants/#{merchant_1.id}"
        expect(page).to have_content(new_name)
        expect(page).to_not have_content(old_name)
    end

    it 'redirects to the Admin Merchant Show page with a flash message saying information has been successfully updated' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name)

        visit admin_merchant_path(merchant_1)
        click_link("Update Merchant Info")

        new_name = Faker::Name.unique.name
        fill_in "Name", with: new_name 
        click_on("Update Information")

        expect(page).to have_content("Merchant information was successfully updated!")
    end

    it 'redirects to the edit form if no name is entered' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name)

        visit admin_merchant_path(merchant_1)

        click_link("Update Merchant Info")

        fill_in "Name", with: ""
        click_on("Update Information")

        expect(current_path).to eq "/admin/merchants/#{merchant_1.id}/edit"
        expect(page).to have_content('Please enter a name.')
    end
end


    