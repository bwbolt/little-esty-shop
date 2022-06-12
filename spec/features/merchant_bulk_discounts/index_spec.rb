require 'rails_helper'

RSpec.describe 'Merchant Bulk Discount Index' do
  before :each do
    @merchant1 = Merchant.create!(name: 'Merchant 1')
    @discount1 = BulkDiscount.create!(percentage: 10, threshold: 10, merchant_id: @merchant1.id)
    @discount2 = BulkDiscount.create!(percentage: 15, threshold: 20, merchant_id: @merchant1.id)
    @discount3 = BulkDiscount.create!(percentage: 30, threshold: 50, merchant_id: @merchant1.id)
  end

  it 'should have a link to it from merchants dashboard', :vcr do
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

  it 'should have a link to a working discount creation form', :vcr do
    visit merchant_bulk_discounts_path(@merchant1)

    click_on 'Create New Discount'

    expect(current_path).to eq(new_merchant_bulk_discount_path(@merchant1))

    within '#threshold' do
      select(100)
    end
    within '#percentage' do
      select(70)
    end

    click_on 'Create'

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    expect(page).to have_content('Buy 100 units, get a 70.0% discount')
  end

  it 'should have a link to delete each discount', :vcr do
    visit merchant_bulk_discounts_path(@merchant1)

    expect(page).to have_content('Buy 10 units, get a 10.0% discount')
    expect(page).to have_content('Buy 20 units, get a 15.0% discount')
    expect(page).to have_content('Buy 50 units, get a 30.0% discount')

    within "#discount-#{@discount1.id}" do
      click_on 'Delete Discount'
    end

    expect(current_path).to eq(merchant_bulk_discounts_path(@merchant1))

    expect(page).to_not have_content('Buy 10 units, get a 10.0% discount')
    expect(page).to have_content('Buy 20 units, get a 15.0% discount')
    expect(page).to have_content('Buy 50 units, get a 30.0% discount')
  end

  it 'should have a section of upcoming holidays', :vcr do
    visit merchant_bulk_discounts_path(@merchant1)

    within '#holidays' do
      expect(page).to have_content('Juneteenth')
      expect(page).to have_content('Independence Day')
      expect(page).to have_content('Labour Day')
    end
  end
end
