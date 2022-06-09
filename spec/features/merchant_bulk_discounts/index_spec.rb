require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')
    @discount1 = BulkDiscount.create!(percentage: 10, threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 15, threshold: 20, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 30, threshold: 50, merchant_id: @merchant1.id)
  end
  it 'should have a link to it from merchants dashboard' do
    visit merchant_dashboard_index_path(@merchant1)

    click_on 'My Discounts'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    within "#discount-#{@discount1.id}" do
      expect(page).to have_content(@discount1.percentage)
      expect(page).to have_content(@discount1.threshold)
      expect(page).to have_link('View Discount')
    end
    within "#discount-#{@discount2.id}" do
      expect(page).to have_content(@discount2.percentage)
      expect(page).to have_content(@discount2.threshold)
      expect(page).to have_link('View Discount')
    end
    within "#discount-#{@discount3.id}" do
      expect(page).to have_content(@discount3.percentage)
      expect(page).to have_content(@discount3.threshold)
      expect(page).to have_link('View Discount')
    end
  end
end
