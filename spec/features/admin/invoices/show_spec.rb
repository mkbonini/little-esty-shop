require 'rails_helper'

RSpec.describe 'Admin Invoices Show Page' do
  before :each do
    Faker::UniqueGenerator.clear 
    @merchant_1 = Merchant.create!(name: Faker::Company.unique.name)
    @merchant_2 = Merchant.create!(name: Faker::Company.unique.name)
    
    @customer_1 = Customer.create!(first_name: Faker::Name.unique.first_name, last_name: Faker::Name.unique.last_name)
    
    @item_1 = Item.create!( name: Faker::Commerce.unique.product_name, 
                            description: 'Our first test item', 
                            unit_price: rand(100..10000), 
                            merchant_id: @merchant_1.id)

    @item_2 = Item.create!( name: Faker::Commerce.unique.product_name, 
                            description: 'Our second test item', 
                            unit_price: rand(100..10000), 
                            merchant_id: @merchant_1.id)

    @item_3 = Item.create!( name: Faker::Commerce.unique.product_name, 
                            description: 'Our third test item', 
                            unit_price: rand(100..10000), 
                            merchant_id: @merchant_2.id)

    @invoice_1 = Invoice.create!( status: 'completed', 
                                  customer_id: @customer_1.id)

    @invoice_2 = Invoice.create!( status: 'cancelled', 
                                  customer_id: @customer_1.id)
    
    @invoice_3 = Invoice.create!( status: 'in progress', 
                                  customer_id: @customer_1.id)

    @invoice_item_1 = InvoiceItem.create!(quantity: 1, 
                                          unit_price: 5000, 
                                          status: 'shipped', 
                                          item_id: @item_1.id, 
                                          invoice_id: @invoice_1.id)

    @invoice_item_2 = InvoiceItem.create!(quantity: 5, 
                                          unit_price: 10000, 
                                          status: 'shipped', 
                                          item_id: @item_2.id, 
                                          invoice_id: @invoice_1.id)

    @invoice_item_3 = InvoiceItem.create!(quantity: rand(1..10), 
                                          unit_price: 15000, 
                                          status: 'shipped', 
                                          item_id: @item_1.id, 
                                          invoice_id: @invoice_2.id)

    @invoice_item_4 = InvoiceItem.create!(quantity: rand(1..10), 
                                          unit_price: 25000, 
                                          status: 'shipped', 
                                          item_id: @item_3.id, 
                                          invoice_id: @invoice_3.id)
  end
  
  it 'shows all attributes related to an invoice' do
    visit "/admin/invoices/#{@invoice_1.id}"

    expect(page).to have_content(@invoice_1.id)
    expect(page).to have_content(@invoice_1.status)
    expect(page).to have_content(@invoice_1.created_at.strftime("%A, %B %d, %Y"))
    expect(page).to have_content(@invoice_1.customer.first_name.titlecase)
    expect(page).to have_content(@invoice_1.customer.last_name.titlecase)
  end

  it 'shows information for all of the invoice items on an invoice' do
    visit "/admin/invoices/#{@invoice_1.id}"

    within '#invoice-item-details' do
      within "#invoice-item-#{@invoice_item_1.id}" do
        expect(page).to have_content(@invoice_item_1.item.name)
        expect(page).to have_content(@invoice_item_1.quantity)
        expect(page).to have_content('$50.00')
        expect(page).to have_content(@invoice_item_1.status.titlecase)
      end

      within "#invoice-item-#{@invoice_item_2.id}" do
        expect(page).to have_content(@invoice_item_2.item.name)
        expect(page).to have_content(@invoice_item_2.quantity)
        expect(page).to have_content('$100.00')
        expect(page).to have_content(@invoice_item_2.status.titlecase)
      end

      expect(page).to_not have_content(@invoice_item_4.item.name)
    end
  end
  
  it 'shows the total revenue that will be generated for the invoice' do
    visit "/admin/invoices/#{@invoice_1.id}"

    within '#invoice-details' do
      expect(page).to have_content('$550.00')
    end
  end

  it 'has a select field for invoice status that can update the status and redirect the user' do
    visit "/admin/invoices/#{@invoice_1.id}"

    within "#invoice-details" do
      expect(page).to have_content("#{@invoice_1.status}")
      select "completed", :from => "status"
      click_on("Update Invoice Status")
      expect(current_path).to eq("/admin/invoices/#{@invoice_1.id}")
      expect(page).to have_content("completed")
    end
  end

  it 'shows total and discounted revenue' do
    merchant = Merchant.create!(name: 'amazon')
    customer = Customer.create!(first_name: 'Billy', last_name: 'Bob')
    item_1 = Item.create!(name: 'pet rock', description: 'a rock you pet', unit_price: 10000, merchant_id: merchant.id)
    item_2 = Item.create!(name: 'ferbie', description: 'monster toy', unit_price: 66600, merchant_id: merchant.id)
    invoice_1 = Invoice.create!(status: 'completed', customer_id: customer.id)
    discount_1 = BulkDiscount.create!(quantity: 10, discount: 0.20, merchant_id: merchant.id)
    discount_2 = BulkDiscount.create!(quantity: 15, discount: 0.30, merchant_id: merchant.id)


    InvoiceItem.create!(quantity: 11, unit_price: 100, status: 'shipped', item: item_1, invoice: invoice_1)
    InvoiceItem.create!(quantity: 16, unit_price: 10, status: 'shipped', item: item_2, invoice: invoice_1)

    visit admin_invoice_path(invoice_1)

    within "#invoice-details" do
        expect(page).to have_content("Total Revenue: $12.60")
        expect(page).to have_content("Discounted Revenue: $9.92")
    end
end
end

