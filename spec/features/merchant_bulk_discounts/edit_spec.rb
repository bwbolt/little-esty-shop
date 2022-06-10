require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Edit' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')
    @discount1 = BulkDiscount.create!(percentage: 10, threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 15, threshold: 20, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 30, threshold: 50, merchant_id: @merchant1.id)
  end

  it 'should have a link to it from a show page' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    click_on 'Edit This Discount'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))
  end

  it 'should update the discounts information' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    within '#info' do
      expect(page).to have_content('If a customer buys 10 unit/s, they get a 10.0% discount.')
    end

    click_on 'Edit This Discount'

    expect(current_path).to eq(edit_merchant_bulk_discount_path(@merchant1, @discount1))

    select(1)

    click_on 'Update Discount'

    expect(current_path).to eq(merchant_bulk_discount_path(@merchant1, @discount1))

    within '#info' do
      expect(page).to have_content('If a customer buys 1 unit/s, they get a 10.0% discount.')
    end
  end
end
