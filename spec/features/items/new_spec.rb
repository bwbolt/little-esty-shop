require 'rails_helper'

RSpec.describe 'create item page' do
  it 'can create an item' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_2 = merchant_1.items.create!(name: 'Gold Ring', description: 'There are many rings of power...',
                                      unit_price: 4999)
    item_3 = merchant_1.items.create!(name: 'Silver Ring', description: 'A simple, classic, and versatile piece',
                                      unit_price: 2999)

    visit merchant_items_path(merchant_1.id)

    expect(page).to_not have_content('Dangly Earings')

    click_link 'Create Item'

    expect(current_path).to eq(new_merchant_item_path(merchant_1.id))

    fill_in 'name', with: 'Dangly Earings'
    fill_in 'description', with: 'They tickle your neck.'
    fill_in 'unit_price', with: '2000'
    click_button 'Submit'

    expect(current_path).to eq(merchant_items_path(merchant_1.id))
    expect(page).to have_content('Dangly Earings')
    expect(Item.last.status).to eq('Disabled')
  end
end
