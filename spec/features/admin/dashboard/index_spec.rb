require 'rails_helper'

RSpec.describe 'admin dashboard' do
  describe 'headers' do
    it 'has an admin header' do
      visit admin_dashboard_path

      within '#nav' do
        expect(page).to have_content('Admin Dashboard')
      end
    end

    it 'has links to admin/merchants' do
      visit admin_dashboard_path

      within '#nav' do
        expect(page).to have_link('Merchants')
        click_link 'Merchants'
        expect(current_path).to eq(admin_merchants_path)
      end
    end

    it 'has links to admin/invoices' do
      visit admin_dashboard_path

      within '#nav' do
        expect(page).to have_link('Invoices')
        click_link 'Invoices'
        expect(current_path).to eq(admin_invoices_path)
      end
    end
  end

  describe 'statistics' do
    before :each do
      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      @customer_2 = Customer.create!(first_name: 'Osinski', last_name: 'Cecelia')
      @customer_3 = Customer.create!(first_name: 'Toy', last_name: 'Mariah')
      @customer_4 = Customer.create!(first_name: 'Joy', last_name: 'Braun')
      @merchant = Merchant.create!(name: 'Brylan')
      @item = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
      @invoice_1 = @customer_1.invoices.create!(status: 'completed')
      @invoice_2 = @customer_2.invoices.create!(status: 'completed')
      @invoice_3 = @customer_3.invoices.create!(status: 'completed')
      @invoice_4 = @customer_4.invoices.create!(status: 'completed')
      @ii_1 = @item.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'shipped',
                                          created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @ii_2 = @item.invoice_items.create!(invoice_id: @invoice_2.id, quantity: 5, unit_price: 400, status: 'packaged',
                                          created_at: Time.parse('2012-05-27 14:54:09 UTC'))
      @ii_3 = @item.invoice_items.create!(invoice_id: @invoice_3.id, quantity: 1, unit_price: 400, status: 'shipped',
                                          created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @ii_4 = @item.invoice_items.create!(invoice_id: @invoice_4.id, quantity: 7, unit_price: 400, status: 'packaged',
                                          created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @invoice_1.transactions.create!(credit_card_number: '4654405418249632', result: 'success')
      @invoice_1.transactions.create!(credit_card_number: '4654405418249631', result: 'success')
      @invoice_1.transactions.create!(credit_card_number: '4654405418249633', result: 'success')
      @invoice_1.transactions.create!(credit_card_number: '4654405418249635', result: 'success')
      @invoice_2.transactions.create!(credit_card_number: '5654405418249632', result: 'success')
      @invoice_2.transactions.create!(credit_card_number: '5654405418249631', result: 'success')
      @invoice_3.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
      @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'failed')
      @invoice_3.transactions.create!(credit_card_number: '6654405418249631', result: 'failed')
      @invoice_4.transactions.create!(credit_card_number: '6654405418249632', result: 'success')
    end

    it 'shows the top 5 customers and their order count' do
      visit admin_dashboard_path

      expect(page).to have_content("#{@customer_1.first_name} #{@customer_1.last_name} 4")
      expect(page).to have_content("#{@customer_2.first_name} #{@customer_2.last_name} 2")
      expect(page).to have_content("#{@customer_3.first_name} #{@customer_3.last_name} 1")
      expect(page).to have_content("#{@customer_4.first_name} #{@customer_4.last_name} 1")
    end

    it 'shows a section of incomplete invoices' do
      visit admin_dashboard_path
      within '#incomplete_invoices' do
        expect(page).to have_content(@ii_2.id.to_s)
        expect(page).to have_content(@ii_4.id.to_s)

        expect(page).to have_link(@ii_2.id.to_s)

        click_link(@ii_2.id.to_s)
      end
      expect(current_path).to eq(admin_invoices_path(@ii_2.id))
    end

    it 'shows dates next to the incomplete invoices' do
      visit admin_dashboard_path
      within '#incomplete_invoices' do
        expected_date1 = 'Tuesday, March 27 2012'
        expected_date2 = 'Sunday, May 27 2012'

        expect(page).to have_content(expected_date1)
        expect(page).to have_content(expected_date2)
        expect(expected_date1).to appear_before(expected_date2)
      end
    end
  end
end
