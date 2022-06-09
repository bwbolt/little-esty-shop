require 'rails_helper'

RSpec.describe 'Admin Merchant Index', type: :feature do
  before :each do
    @m1 = Merchant.create!(name: 'Merchant 1')
    @m2 = Merchant.create!(name: 'Merchant 2', status: 0)
    @m3 = Merchant.create!(name: 'Merchant 3')
    @m4 = Merchant.create!(name: 'Merchant 4', status: 0)
    @m5 = Merchant.create!(name: 'Merchant 5', status: 0)
    @m6 = Merchant.create!(name: 'Merchant 6')

    @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
    @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

    @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i2 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i3 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i4 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i5 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i6 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i7 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i8 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i9 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i10 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i11 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))
    @i12 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-25 14:54:09 UTC'))

    @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
    @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                           merchant_id: @m2.id)
    @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m3.id)
    @item_4 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m4.id)
    @item_5 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m5.id)

    @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 12, unit_price: 10, status: 0)
    @ii_2 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_2.id, quantity: 6, unit_price: 8, status: 1)
    @ii_3 = InvoiceItem.create!(invoice_id: @i3.id, item_id: @item_3.id, quantity: 16, unit_price: 5, status: 2)
    @ii_4 = InvoiceItem.create!(invoice_id: @i4.id, item_id: @item_3.id, quantity: 2, unit_price: 5, status: 2)
    @ii_5 = InvoiceItem.create!(invoice_id: @i5.id, item_id: @item_3.id, quantity: 10, unit_price: 5, status: 2)
    @ii_6 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_3.id, quantity: 7, unit_price: 5, status: 2)
    @ii_7 = InvoiceItem.create!(invoice_id: @i2.id, item_id: @item_3.id, quantity: 1, unit_price: 5, status: 2)

    @t1 = Transaction.create!(credit_card_number: 203_942, result: 1, invoice_id: @i1.id)
    @t2 = Transaction.create!(credit_card_number: 230_948, result: 1, invoice_id: @i2.id)
    @t3 = Transaction.create!(credit_card_number: 234_092, result: 1, invoice_id: @i3.id)
    @t4 = Transaction.create!(credit_card_number: 230_429, result: 1, invoice_id: @i5.id)
    @t5 = Transaction.create!(credit_card_number: 102_938, result: 1, invoice_id: @i6.id)
    @t6 = Transaction.create!(credit_card_number: 102_938, result: 1, invoice_id: @i1.id)

    visit admin_merchants_path
  end

  it 'should display all merchants by name' do
    expect(page).to have_link(@m1.name)
    expect(page).to have_link(@m2.name)
    expect(page).to have_link(@m3.name)
    expect(page).to have_link(@m4.name)
    expect(page).to have_link(@m5.name)
    expect(page).to have_link(@m6.name)
  end

  it 'should allow disabling and enabling a merchant' do
    within "#disabled-#{@m1.id}" do
      click_on 'Enable'
    end

    expect(current_path).to eq(admin_merchants_path)

    within "#enabled-#{@m1.id}" do
      expect(page).to have_content(@m1.name)
      expect(page).to have_button('Disable')
    end
  end

  it 'should have two sections for Enabled/Disabled Merchants' do
    within '#disabled' do
      within "#disabled-#{@m1.id}" do
        click_on 'Enable'
      end
    end

    within '#enabled' do
      within "#enabled-#{@m1.id}" do
        expect(page).to have_content(@m1.name)
        expect(page).to have_button('Disable')
      end
    end
  end

  it 'should have a link to a working new merchant form' do
    expect(page).to have_content('Create New Merchant')

    click_on 'Create New Merchant'

    expect(current_path).to eq(new_admin_merchant_path)

    fill_in :name, with: 'Bryces Goodies'
    click_button 'Save'

    expect(current_path).to eq(admin_merchants_path)

    within('#disabled') do
      expect(page).to have_content('Bryces Goodies')
    end
  end

  it 'should have a list of top 5 merchants by revenue with that metric displayed' do
    within '#top_five_merchants' do
      expect(page).to have_link(@m1.name)
      expect(page).to have_link(@m2.name)
      expect(page).to have_link(@m3.name)
    end

    within '#top_five_merchants' do
      expect(@m1.name).to appear_before(@m3.name)
      expect(@m3.name).to appear_before(@m2.name)
      expect(@m2.name).to_not appear_before(@m3.name)
    end
  end

  it 'should have a top selling day for the top 5 merchants' do
    within "#top_day-#{@m1.id}" do
      expect(page).to have_content('03/25/12')
    end
    within "#top_day-#{@m2.id}" do
      expect(page).to have_content('03/25/12')
    end
    within "#top_day-#{@m3.id}" do
      expect(page).to have_content('03/25/12')
    end
  end
end
