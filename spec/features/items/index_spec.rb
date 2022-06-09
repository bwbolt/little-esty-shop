require 'rails_helper'

RSpec.describe 'Item Index' do
  it 'lists names of all items' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500)
    item_2 = merchant_1.items.create!(name: 'Gold Ring', description: 'There are many rings of power...',
                                      unit_price: 4999)
    item_3 = merchant_1.items.create!(name: 'Silver Ring', description: 'A simple, classic, and versatile piece',
                                      unit_price: 2999)
    merchant_2 = Merchant.create(name: "Antique's by Annie")
    item_4 = merchant_2.items.create!(name: "1920's Driving Gloves", description: 'Leather', unit_price: 2999)

    visit merchant_items_path(merchant_1.id)

    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_2.name)
    expect(page).to have_content(item_3.name)

    expect(page).to_not have_content(item_4.name)
  end

  it 'has link to all of the merchants items' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500)

    visit merchant_items_path(merchant_1.id)

    click_link 'Dangly Earings'

    expect(current_path).to eq(merchant_item_path(merchant_1.id, item_1.id))
  end

  it 'has secton for enabled items and disabled items' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500,
                                      status: 'Enabled')
    item_2 = merchant_1.items.create!(name: 'Gold Ring', description: 'There are many rings of power...',
                                      unit_price: 4999, status: 'Disabled')
    item_3 = merchant_1.items.create!(name: 'Silver Ring', description: 'A simple, classic, and versatile piece',
                                      unit_price: 2999, status: 'Disabled')

    visit merchant_items_path(merchant_1.id)

    within('#disabled') do
      expect(page).to have_content(item_2.name)
      expect(page).to have_content(item_3.name)
      expect(page).to_not have_content(item_1.name)
    end

    within('#enabled') do
      expect(page).to have_content(item_1.name)
      expect(page).to_not have_content(item_3.name)
    end
  end

  it 'has a button to change item status to Enabled' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500,
                                      status: 'Enabled')
    item_2 = merchant_1.items.create!(name: 'Gold Ring', description: 'There are many rings of power...',
                                      unit_price: 4999, status: 'Disabled')
    item_3 = merchant_1.items.create!(name: 'Silver Ring', description: 'A simple, classic, and versatile piece',
                                      unit_price: 2999, status: 'Disabled')

    visit merchant_items_path(merchant_1.id)

    within('#disabled-1') do
      click_button 'Enable Item'
    end

    expect(current_path).to eq(merchant_items_path(merchant_1.id))

    within('#disabled') do
      expect(page).to_not have_content(item_2.name)
      expect(page).to have_content(item_3.name)
    end

    within('#enabled') do
      expect(page).to have_content(item_1.name)
      expect(page).to have_content(item_2.name)
    end
  end

  it 'has a button to change item status to Disabled' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500,
                                      status: 'Enabled')
    item_2 = merchant_1.items.create!(name: 'Gold Ring', description: 'There are many rings of power...',
                                      unit_price: 4999, status: 'Disabled')
    item_3 = merchant_1.items.create!(name: 'Silver Ring', description: 'A simple, classic, and versatile piece',
                                      unit_price: 2999, status: 'Disabled')

    visit merchant_items_path(merchant_1.id)

    within('#enabled-0') do
      click_button 'Disable Item'
    end

    nu_changed_item = Item.last

    expect(current_path).to eq(merchant_items_path(merchant_1.id))
    expect('Disabled Items').to appear_before(nu_changed_item.name)
    expect(nu_changed_item.status).to eq('Disabled')
  end

  it 'has a link to create a new item'  do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500,
                                      status: 'Enabled')
    item_2 = merchant_1.items.create!(name: 'Gold Ring', description: 'There are many rings of power...',
                                      unit_price: 4999, status: 'Disabled')
    item_3 = merchant_1.items.create!(name: 'Silver Ring', description: 'A simple, classic, and versatile piece',
                                      unit_price: 2999, status: 'Disabled')

    visit merchant_items_path(merchant_1.id)

    click_link 'Create Item'

    expect(current_path).to eq(new_merchant_item_path(merchant_1.id))
  end

  it 'lists 5 most popular items in order of total revenue' do
    merchant = Merchant.create!(name: 'Office Supplies')
    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice_1 = customer_1.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-27 14:54:09 UTC'))
    item_1 = merchant.items.create!(name: 'Pencil', unit_price: 100, description: 'Writes things.')
    item_2 = merchant.items.create!(name: 'Eraser', unit_price: 200, description: 'Does things.')
    item_3 = merchant.items.create!(name: 'Pen', unit_price: 300, description: 'Helps things.')
    item_4 = merchant.items.create!(name: 'Calculator', unit_price: 400, description: 'Considers things.')
    item_5 = merchant.items.create!(name: 'Stapler', unit_price: 500, description: 'Wishes things.')
    item_6 = merchant.items.create!(name: 'Computer', unit_price: 600, description: 'Hopes things.')
    item_7 = merchant.items.create!(name: 'Backpack', unit_price: 700, description: 'Forgets things.')
    item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 1, unit_price: 400, status: 2)
    item_2.invoice_items.create!(invoice_id: invoice_1.id, quantity: 2, unit_price: 500, status: 2)
    item_3.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 600, status: 2)
    item_4.invoice_items.create!(invoice_id: invoice_1.id, quantity: 4, unit_price: 700, status: 2)
    item_5.invoice_items.create!(invoice_id: invoice_1.id, quantity: 5, unit_price: 800, status: 2)
    invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')

    customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
    invoice_2 = customer_2.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-26 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-26 09:54:09 UTC'))
    item_3.invoice_items.create!(invoice_id: invoice_2.id, quantity: 1, unit_price: 400, status: 2)
    item_4.invoice_items.create!(invoice_id: invoice_2.id, quantity: 2, unit_price: 500, status: 2)
    item_5.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 600, status: 2)
    item_6.invoice_items.create!(invoice_id: invoice_2.id, quantity: 4, unit_price: 700, status: 2)
    item_7.invoice_items.create!(invoice_id: invoice_2.id, quantity: 5, unit_price: 800, status: 2)
    invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')

    visit merchant_items_path(merchant.id)

    expect(Item.most_popular_items).to eq([item_5, item_7, item_4, item_6, item_3])

    within('#popular') do
      expect('Stapler').to appear_before('Backpack')
      expect('Calculator').to appear_before('Computer')
      expect('Computer').to appear_before('Pen')
      expect(page).to_not have_content(item_1.name)
      expect(page).to_not have_content(item_2.name)
    end
  end

  it 'has link to each item show page in top items section' do
    merchant = Merchant.create!(name: 'Office Supplies')
    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice_1 = customer_1.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-26 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-26 09:54:09 UTC'))
    item_1 = merchant.items.create!(name: 'Pencil', unit_price: 100, description: 'Writes things.')
    item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 1, unit_price: 400, status: 2)
    invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')

    visit merchant_items_path(merchant.id)

    within('#popular') do
      click_link 'Pencil'
    end

    expect(current_path).to eq(merchant_item_path(merchant.id, item_1.id))
  end

  it 'has total revenue for each item'  do
    merchant = Merchant.create!(name: 'Office Supplies')
    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice_1 = customer_1.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-27 14:54:09 UTC'))
    item_1 = merchant.items.create!(name: 'Pencil', unit_price: 100, description: 'Writes things.')
    item_2 = merchant.items.create!(name: 'Eraser', unit_price: 200, description: 'Does things.')
    item_3 = merchant.items.create!(name: 'Pen', unit_price: 300, description: 'Helps things.')
    item_4 = merchant.items.create!(name: 'Calculator', unit_price: 400, description: 'Considers things.')
    item_5 = merchant.items.create!(name: 'Stapler', unit_price: 500, description: 'Wishes things.')
    item_6 = merchant.items.create!(name: 'Computer', unit_price: 600, description: 'Hopes things.')
    item_7 = merchant.items.create!(name: 'Backpack', unit_price: 700, description: 'Forgets things.')
    item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 1, unit_price: 400, status: 2)
    item_2.invoice_items.create!(invoice_id: invoice_1.id, quantity: 2, unit_price: 500, status: 2)
    item_3.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 600, status: 2)
    item_4.invoice_items.create!(invoice_id: invoice_1.id, quantity: 4, unit_price: 700, status: 2)
    item_5.invoice_items.create!(invoice_id: invoice_1.id, quantity: 5, unit_price: 800, status: 2)
    invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')

    customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
    invoice_2 = customer_2.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-26 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-26 09:54:09 UTC'))
    item_3.invoice_items.create!(invoice_id: invoice_2.id, quantity: 1, unit_price: 400, status: 2)
    item_4.invoice_items.create!(invoice_id: invoice_2.id, quantity: 2, unit_price: 500, status: 2)
    item_5.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 600, status: 2)
    item_6.invoice_items.create!(invoice_id: invoice_2.id, quantity: 4, unit_price: 700, status: 2)
    item_7.invoice_items.create!(invoice_id: invoice_2.id, quantity: 5, unit_price: 800, status: 2)
    invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')

    visit merchant_items_path(merchant.id)

    within('#popular-0') do
      expect(page).to have_content('$58.00')
    end

    within('#popular-1') do
      expect(page).to have_content('$40.00')
    end

    within('#popular-2') do
      expect(page).to have_content('$38.00')
    end

    within('#popular-3') do
      expect(page).to have_content('$28.00')
    end

    within('#popular-4') do
      expect(page).to have_content('$22.00')
    end
  end

  it 'shows top items best day' do
    merchant = Merchant.create!(name: 'Office Supplies')
    customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
    invoice_1 = customer_1.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-27 14:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-27 14:54:09 UTC'))
    item_1 = merchant.items.create!(name: 'Pencil', unit_price: 100, description: 'Writes things.')
    item_2 = merchant.items.create!(name: 'Eraser', unit_price: 200, description: 'Does things.')
    item_3 = merchant.items.create!(name: 'Pen', unit_price: 300, description: 'Helps things.')
    item_4 = merchant.items.create!(name: 'Calculator', unit_price: 400, description: 'Considers things.')
    item_5 = merchant.items.create!(name: 'Stapler', unit_price: 500, description: 'Wishes things.')
    item_6 = merchant.items.create!(name: 'Computer', unit_price: 600, description: 'Hopes things.')
    item_7 = merchant.items.create!(name: 'Backpack', unit_price: 700, description: 'Forgets things.')
    item_1.invoice_items.create!(invoice_id: invoice_1.id, quantity: 1, unit_price: 400, status: 2)
    item_2.invoice_items.create!(invoice_id: invoice_1.id, quantity: 2, unit_price: 500, status: 2)
    item_3.invoice_items.create!(invoice_id: invoice_1.id, quantity: 3, unit_price: 600, status: 2)
    item_4.invoice_items.create!(invoice_id: invoice_1.id, quantity: 4, unit_price: 700, status: 2)
    item_5.invoice_items.create!(invoice_id: invoice_1.id, quantity: 5, unit_price: 800, status: 2)
    invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')

    customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
    invoice_2 = customer_2.invoices.create!(status: 'completed',
                                            created_at: Time.parse('2012-03-26 09:54:09 UTC'),
                                            updated_at: Time.parse('2012-03-26 09:54:09 UTC'))
    item_3.invoice_items.create!(invoice_id: invoice_2.id, quantity: 1, unit_price: 400, status: 2)
    item_4.invoice_items.create!(invoice_id: invoice_2.id, quantity: 2, unit_price: 500, status: 2)
    item_5.invoice_items.create!(invoice_id: invoice_2.id, quantity: 3, unit_price: 600, status: 2)
    item_6.invoice_items.create!(invoice_id: invoice_2.id, quantity: 4, unit_price: 700, status: 2)
    item_7.invoice_items.create!(invoice_id: invoice_2.id, quantity: 5, unit_price: 800, status: 2)
    invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')

    visit merchant_items_path(merchant.id)

    within('#popular-0') do
      expect(page).to have_content('03/27/2012')
    end

    within('#popular-1') do
      expect(page).to have_content('03/26/2012')
    end

    within('#popular-2') do
      expect(page).to have_content('03/27/2012')
    end

    within('#popular-3') do
      expect(page).to have_content('03/26/2012')
    end

    within('#popular-4') do
      expect(page).to have_content('03/27/2012')
    end
  end
end
