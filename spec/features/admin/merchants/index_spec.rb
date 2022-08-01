require 'rails_helper' 
require 'faker' 
require 'pry'

RSpec.describe 'Admin Merchants Index' do 
    # Admin Merchants Index
    # As an admin,
    # When I visit the admin merchants index (/admin/merchants)
    # Then I see the name of each merchant in the system
    it 'shows the name of each merchant in the system' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_3 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_4 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

        visit admin_merchants_path
        # save_and_open_page

        within('#e-merchant-0') do 
            expect(page).to have_content(merchant_1.name)
        end

        within('#e-merchant-1') do 
            expect(page).to have_content(merchant_2.name)
        end

        within('#e-merchant-2') do 
            expect(page).to have_content(merchant_3.name)
        end

        within('#e-merchant-3') do 
            expect(page).to have_content(merchant_4.name)
        end
    end

    # Admin Merchant Show
    # As an admin,
    # When I click on the name of a merchant from the admin merchants index page,
    # Then I am taken to that merchant's admin show page (/admin/merchants/merchant_id)
    # And I see the name of that merchant
    it 'has links to the merchants admin show page' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_3 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_4 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

        visit admin_merchants_path

        within('#e-merchant-0') do 
            expect(page).to have_link(merchant_1.name)
        end

        within('#e-merchant-1') do 
            expect(page).to have_link(merchant_2.name)
        end

        within('#e-merchant-2') do 
            expect(page).to have_link(merchant_3.name)
        end

        within('#e-merchant-3') do 
            expect(page).to have_link(merchant_4.name)
            click_link(merchant_4.name)
        end

        expect(current_path).to eq("/admin/merchants/#{merchant_4.id}")
        expect(page).to have_content(merchant_4.name)
        expect(page).to_not have_content(merchant_1.name)
        expect(page).to_not have_content(merchant_2.name)
        expect(page).to_not have_content(merchant_3.name)
    end

    # As an admin,
    # When I visit the admin merchants index
    # Then next to each merchant name I see a button to disable or enable that merchant.
    it 'has buttons to disable or enable Merchants' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name)
        merchant_3 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_4 = Merchant.create!(name: Faker::Name.unique.name)

        visit admin_merchants_path

        within("#disabled") do 
            expect(page).to have_content merchant_1.name 
            expect(page).to have_content merchant_2.name 
            expect(page).to have_content merchant_4.name 
            expect(page).to_not have_content merchant_3.name
        end

        within("#enabled") do 
            expect(page).to have_content merchant_3.name 
            expect(page).to_not have_content merchant_1
            expect(page).to_not have_content merchant_2
            expect(page).to_not have_content merchant_4
        end

        within("#d-merchant-0") do 
            expect(page).to have_content merchant_1.name 
            expect(page).to have_button "Enable"
        end

        within("#d-merchant-1") do 
            expect(page).to have_content merchant_2.name 
            expect(page).to have_button "Enable"
        end

        within("#d-merchant-2") do 
            expect(page).to have_content merchant_4.name 
            expect(page).to have_button "Enable"
        end

        within("#e-merchant-0") do 
            expect(page).to have_content merchant_3.name 
            expect(page).to have_button "Disable"
        end
    end

    # When I click this button
    # Then I am redirected back to the admin merchants index
    # And I see that the merchant's status has changed
    it 'has buttons that changes the merchants status' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_3 = Merchant.create!(name: Faker::Name.unique.name)
        merchant_4 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

        visit admin_merchants_path

        within("#e-merchant-0") do 
            click_on "Disable"
        end

        expect(current_path).to eq "/admin/merchants"

        within("#enabled") do 
            expect(page).to have_content merchant_2.name 
            expect(page).to have_content merchant_4.name 
            expect(page).to_not have_content merchant_1.name
            expect(page).to_not have_content merchant_3.name
        end

        within("#disabled") do 
            expect(page).to have_content merchant_1.name 
            expect(page).to have_content merchant_3.name 
            expect(page).to_not have_content merchant_2
            expect(page).to_not have_content merchant_4
        end

        visit admin_merchants_path

        within("#d-merchant-1") do 
            click_on "Enable"
        end

        within("#enabled") do 
            expect(page).to have_content merchant_2.name 
            expect(page).to have_content merchant_3.name
            expect(page).to have_content merchant_4.name 
            expect(page).to_not have_content merchant_1.name
        end

        within("#disabled") do 
            expect(page).to have_content merchant_1.name 
            expect(page).to_not have_content merchant_2
            expect(page).to_not have_content merchant_4
            expect(page).to_not have_content merchant_3
        end
    end

    # Admin Merchants Grouped by Status
    # As an admin,
    # When I visit the admin merchants index
    # Then I see two sections, one for "Enabled Merchants" and one for "Disabled Merchants"
    # And I see that each Merchant is listed in the appropriate section
    it 'groups merchants by status' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_3 = Merchant.create!(name: Faker::Name.unique.name)
        merchant_4 = Merchant.create!(name: Faker::Name.unique.name, status: 1)

        visit admin_merchants_path

        within("#enabled") do 
            expect(page).to have_content merchant_2.name 
            expect(page).to have_content merchant_4.name 
            expect(page).to_not have_content merchant_1.name 
            expect(page).to_not have_content merchant_3.name
        end

        within("#disabled") do 
            expect(page).to have_content merchant_1.name 
            expect(page).to have_content merchant_3.name 
            expect(page).to_not have_content merchant_2
            expect(page).to_not have_content merchant_4
        end
    end

    # Admin Merchant Create
    # As an admin,
    # When I visit the admin merchants index
    # I see a link to create a new merchant.
    # When I click on the link,
    # I am taken to a form that allows me to add merchant information.
    it 'has a link to create a new merchant that directs to merchant#new' do 
        Faker::UniqueGenerator.clear 
        merchant_1 = Merchant.create!(name: Faker::Name.unique.name, status: 1)
        merchant_2 = Merchant.create!(name: Faker::Name.unique.name)

        visit admin_merchants_path
        click_link 'New Merchant' 

        expect(current_path).to eq '/admin/merchants/new'
    end
end