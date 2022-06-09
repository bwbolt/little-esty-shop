require 'rails_helper'

RSpec.describe 'merchant item show page' do
  it 'shows all item attributes' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500)

    visit merchant_item_path(merchant_1.id, item_1.id)

    expect(page).to have_content(item_1.name)
    expect(page).to have_content(item_1.description)
    expect(page).to have_content('$15.00')
  end

  it 'has a link to update item info' do
    merchant_1 = Merchant.create(name: "Ray's Handmade Jewelry")
    item_1 = merchant_1.items.create!(name: 'Dangly Earings', description: 'They tickle your neck.', unit_price: 1500)

    visit merchant_item_path(merchant_1.id, item_1.id)

    click_link 'Update Item Info'

    expect(current_path).to eq(edit_merchant_item_path(merchant_1.id, item_1.id))
  end
end
