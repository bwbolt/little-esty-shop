require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Show' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')
    @discount1 = BulkDiscount.create!(percentage: 10, threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 15, threshold: 20, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 30, threshold: 50, merchant_id: @merchant1.id)
  end

  it 'should discplay all information about the particular discount' do
    visit merchant_bulk_discount_path(@merchant1, @discount1)

    within '#info' do
      expect(page).to have_content(@discount1.threshold)
      expect(page).to have_content(@discount1.percentage)
    end
  end
end
