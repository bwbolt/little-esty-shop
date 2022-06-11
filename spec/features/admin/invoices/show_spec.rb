require 'rails_helper'

RSpec.describe 'Admin Invoice Show page' do
  before :each do
    @merchant = Merchant.create!(name: 'Brylan')
    @discount1 = @merchant.bulk_discounts.create(threshold: 3, percentage: 10)
    @discount2 = @merchant.bulk_discounts.create(threshold: 5, percentage: 15)
    @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
    @item_2 = @merchant.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
    @item_3 = @merchant.items.create!(name: 'Marker', unit_price: 400,
                                      description: 'Writes things, but dark, and thicc.')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @customer_2 = Customer.create!(first_name: 'Chael', last_name: 'Sonnen')
    @invoice_1 = @customer_1.invoices.create!(status: 'in progress', created_at: 'Sat, 1 Jan 2022 21:20:02 UTC +00:00')
    @invoice_7 = @customer_1.invoices.create!(status: 'cancelled')
    @invoice_5 = @customer_1.invoices.create!(status: 'in progress')
    @invoice_item_1 = @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                    created_at: Time.parse('2012-03-27 14:54:09 UTC'))
    @invoice_item_2 = @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 5, unit_price: 400, status: 'packaged',
                                                    created_at: Time.parse('2012-03-28 14:54:09 UTC'))

    @invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249631', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249633', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
  end

  it 'displays the invoice information' do
    visit admin_invoice_path(@invoice_1)

    within "#invoice-header-#{@invoice_1.id}" do
      expect(page).to have_content("Invoice ##{@invoice_1.id}")
    end
    within "#invoice-#{@invoice_1.id}" do
      expect(page).to have_content('Created on: Saturday, January 01, 2022')
      expect(page).to have_content("#{@customer_1.first_name} #{@customer_1.last_name}")
      current = find_field('status').value
      expect(current).to eq('in progress')
    end
  end

  it 'displays the invoice items information' do
    visit admin_invoice_path(@invoice_1)
    within "#invoice-items-#{@invoice_item_1.id}" do
      expect(page).to have_content('Pencil 3 $500 packaged')
    end
  end

  it 'displays the ammount of total revenue made by the invoice' do
    visit admin_invoice_path(@invoice_1)
    within "#invoice-#{@invoice_1.id}" do
      expect(page).to have_content("Total Revenue: $#{@invoice_1.total_revenue}")
    end
  end

  it 'can update the status of a invoice item' do
    visit admin_invoice_path(@invoice_1)

    current = find_field('status').value
    expect(current).to eq('in progress')

    select('completed')
    click_on('Update Invoice Status')

    expect(current_path).to eq(admin_invoice_path(@invoice_1))

    updated = find_field('status').value
    expect(updated).to eq('completed')
  end

  it 'can update the status of a invoice item' do
    visit admin_invoice_path(@invoice_7)

    current = find_field('status').value
    expect(current).to eq('cancelled')

    select('in progress')
    click_on('Update Invoice Status')

    expect(current_path).to eq(admin_invoice_path(@invoice_7))

    expect(page).to have_content('in progress')
  end
  it 'can update the status of a invoice item' do
    visit admin_invoice_path(@invoice_5)

    current = find_field('status').value
    expect(current).to eq('in progress')

    select('cancelled')
    click_on('Update Invoice Status')

    expect(current_path).to eq(admin_invoice_path(@invoice_5))

    expect(page).to have_content('cancelled')
  end

  it 'displays the ammount of discounted revenue made by the invoice' do
    visit admin_invoice_path(@invoice_1)
    within "#invoice-#{@invoice_1.id}" do
      expect(page).to have_content("Discounted Revenue: $#{@invoice_1.discounted_revenue.to_i}")
    end
  end
end
