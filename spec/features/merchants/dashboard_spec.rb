require 'rails_helper'

RSpec.describe 'Merchant Dashboard Index', type: :feature do
  before :each do
    @merchant = Merchant.create!(name: 'Saba')
    @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 4, description: 'Writes things.')
    @item_2 = @merchant.items.create!(name: 'Pen', unit_price: 5, description: 'Writes things, but dark.')
    @item_3 = @merchant.items.create!(name: 'Marker', unit_price: 6, description: 'Writes things, but dark, and thicc.')

    @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    @invoice_1 = @customer_1.invoices.create(status: 'completed',
                                             created_at: '2012-03-27 14:54:09 UTC')
    @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 4, status: 0)
    @invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249631', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249633', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
    @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')

    @customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
    @invoice_4 = @customer_2.invoices.create(status: 'completed',
                                             created_at: '2012-03-26 09:54:09 UTC')
    @item_1.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 3, unit_price: 4, status: 1)
    @invoice_4.transactions.create!(credit_card_number: '5654405418249632', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '5654405418249631', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '5654405418249633', result: 'success')
    @invoice_4.transactions.create!(credit_card_number: '5654405418249633', result: 'success')

    @customer_3 = Customer.create!(first_name: 'Toy', last_name: 'Mariah')
    @invoice_7 = @customer_3.invoices.create(status: 'completed',
                                             created_at: '2012-02-26 09:54:09 UTC')
    @item_2.invoice_items.create!(invoice_id: @invoice_7.id, quantity: 4, unit_price: 5, status: 0)
    @invoice_7.transactions.create!(credit_card_number: '6654405418249631', result: 'success')
    @invoice_7.transactions.create!(credit_card_number: '6654405418249631', result: 'success')
    @invoice_7.transactions.create!(credit_card_number: '6654405418249631', result: 'success')

    @customer_4 = Customer.create!(first_name: 'Joy', last_name: 'Braun')
    @invoice_9 = @customer_4.invoices.create(status: 'completed',
                                             created_at: '2012-01-26 09:54:09 UTC')
    @item_2.invoice_items.create!(invoice_id: @invoice_9.id, quantity: 4, unit_price: 5, status: 1)
    @invoice_9.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_9.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_9.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_9.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_9.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    @invoice_9.transactions.create!(credit_card_number: '6654405418249632', result: 'success')

    @customer_6 = Customer.create!(first_name: 'Eileen', last_name: 'Garcia')

    @invoice_14 = @customer_6.invoices.create(status: 'in progress',
                                              created_at: '2012-11-26 09:54:09 UTC')
    @item_2.invoice_items.create!(invoice_id: @invoice_14.id, quantity: 4, unit_price: 5, status: 'pending')
    @invoice_14.transactions.create!(credit_card_number: '6654405418249644', result: 'success')

    @customer_7 = Customer.create!(first_name: 'Smark', last_name: 'Mrains')
    @invoice_13 = @customer_7.invoices.create(status: 'in progress',
                                              created_at: '2012-03-30 09:54:09 UTC')

    @item_2.invoice_items.create!(invoice_id: @invoice_13.id, quantity: 4, unit_price: 5, status: 'pending')
    @invoice_13.transactions.create!(credit_card_number: '6654405418249644', result: 'failed')
  end

  it 'should display the name of the merchant' do
    visit merchant_dashboard_index_path(@merchant.id)

    within '#name' do
      expect(page).to have_content('Saba')
    end
  end

  it 'should have links to merchant items index and merchant invoices index' do
    visit merchant_dashboard_index_path(@merchant.id)

    expect(page).to have_link('My Items')
    expect(page).to have_link('My Invoices')
  end

  it 'should display top 5 customers with number of successful transactions' do
    visit merchant_dashboard_index_path(@merchant.id)

    within "#id-#{@customer_4.id}" do
      expect(page).to have_content(@customer_4.first_name)
      expect(page).to have_content(@customer_4.last_name)
      expect(page).to have_content(6)
      expect(page).to_not have_content(@customer_7.first_name)
    end

    within("#id-#{@customer_1.id}") do
      expect(page).to have_content(@customer_1.first_name)
      expect(page).to have_content(@customer_1.last_name)
      expect(page).to_not have_content(@customer_7.first_name)
      expect(page).to have_content(5)
      expect(@customer_1.first_name).to appear_before(@customer_3.first_name)
      expect(@customer_3.first_name).to_not appear_before(@customer_1.first_name)
    end

    within "#id-#{@customer_2.id}" do
      expect(page).to have_content(@customer_2.first_name)
      expect(page).to have_content(@customer_2.last_name)
      expect(page).to_not have_content(@customer_7.last_name)
      expect(page).to have_content(4)
    end

    within "#id-#{@customer_3.id}" do
      expect(page).to have_content(@customer_3.first_name)
      expect(page).to have_content(@customer_3.last_name)
      expect(page).to have_content(3)
    end

    within "#id-#{@customer_6.id}" do
      expect(page).to have_content(@customer_6.first_name)
      expect(page).to have_content(@customer_6.last_name)
      expect(page).to have_content(1)
    end
  end

  it 'should display unshipped items' do
    visit merchant_dashboard_index_path(@merchant.id)

    within '#id-0' do
      expect(page).to have_content(@item_2.name)
      expect(page).to have_link(@invoice_9.id)
      expect(page).to have_content('Thursday, Jan 26 2012')
      expect(page).to_not have_content(@item_3.name)
    end

    within '#id-1' do
      expect(page).to have_content(@item_1.name)
      expect(page).to have_link(@invoice_4.id)
      expect(page).to have_content('Monday, Mar 26 2012')
      expect(page).to_not have_content('Tuesday, Mar 27 2012')
      expect(@item_1.name).to_not appear_before(@item_2.name)

      click_link @invoice_4.id.to_s
      expect(current_path).to eq(merchant_invoice_path(@merchant, @invoice_4))
    end
  end

  it 'has repo name from gitgub' do
    visit merchant_dashboard_index_path(@merchant.id)

    expect(page).to have_content('Little Esty Shop')
  end
end
