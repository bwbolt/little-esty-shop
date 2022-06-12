require 'rails_helper'

RSpec.describe Invoice, type: :model do
  describe 'relationships' do
    it { should belong_to(:customer) }
    it { should have_many(:transactions) }

    it { should have_many(:invoice_items) }
    it { should have_many(:items).through(:invoice_items) }
  end

  describe 'validations' do
    it { should validate_presence_of(:status) }
  end

  describe 'class methods' do
    it 'can use a model class method to calculate a invoices total revenue' do
      @merchant = Merchant.create!(name: 'Brylan')
      @item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
      @item_2 = @merchant.items.create!(name: 'Pen', unit_price: 375, description: 'Writes things, but dark.')
      @item_3 = @merchant.items.create!(name: 'Marker', unit_price: 400,
                                        description: 'Writes things, but dark, and thicc.')

      @customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
      @invoice_1 = @customer_1.invoices.create!(status: 'completed',
                                                created_at: 'Wed, 01 Jan 2022 21:20:02 UTC +00:00')
      @invoice_7 = @customer_1.invoices.create!(status: 'completed')
      @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged',
                                    created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 1, unit_price: 375, status: 'packaged',
                                    created_at: Time.parse('2012-03-28 14:54:09 UTC'))
      expect(@invoice_1.total_revenue).to eq(1575)
    end

    it '#best_day' do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @m2 = Merchant.create!(name: 'Merchant 2', status: 0)
      @m3 = Merchant.create!(name: 'Merchant 3')
      @m4 = Merchant.create!(name: 'Merchant 4', status: 0)
      @m5 = Merchant.create!(name: 'Merchant 5', status: 0)
      @m6 = Merchant.create!(name: 'Merchant 6')

      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-27 14:54:09 UTC'))
      @i2 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i3 = Invoice.create!(customer_id: @c2.id, status: 2, created_at: Time.parse('2012-03-26 14:54:09 UTC'))
      @i4 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i5 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i6 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i7 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i8 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i9 = Invoice.create!(customer_id: @c1.id, status: 2)
      @i10 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i11 = Invoice.create!(customer_id: @c2.id, status: 2)
      @i12 = Invoice.create!(customer_id: @c2.id, status: 2)

      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                             merchant_id: @m2.id)
      @item_3 = Item.create!(name: 'Brush', description: 'This takes out tangles', unit_price: 5, merchant_id: @m3.id)
      @item_4 = Item.create!(name: 'test', description: 'lalala', unit_price: 6, merchant_id: @m4.id)
      @item_5 = Item.create!(name: 'rest', description: 'dont test me', unit_price: 12, merchant_id: @m5.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
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

      expect(Invoice.best_day.created_at).to eq(@i3.created_at)
    end

    it '#discounted_revenue' do
      @m1 = Merchant.create!(name: 'Merchant 1')
      @discount1 = BulkDiscount.create!(percentage: 10, threshold: 5, merchant_id: @m1.id)

      @c1 = Customer.create!(first_name: 'Yo', last_name: 'Yoz')
      @c2 = Customer.create!(first_name: 'Hey', last_name: 'Heyz')

      @i1 = Invoice.create!(customer_id: @c1.id, status: 2, created_at: Time.parse('2012-03-27 14:54:09 UTC'))

      @item_1 = Item.create!(name: 'Shampoo', description: 'This washes your hair', unit_price: 10, merchant_id: @m1.id)
      @item_2 = Item.create!(name: 'Conditioner', description: 'This makes your hair shiny', unit_price: 8,
                             merchant_id: @m1.id)

      @ii_1 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_1.id, quantity: 1, unit_price: 10, status: 0)
      @ii_2 = InvoiceItem.create!(invoice_id: @i1.id, item_id: @item_2.id, quantity: 6, unit_price: 8, status: 1)

      expect(@i1.total_revenue).to eq(58)
      expect(@i1.discounted_revenue).to eq(53.2)
    end
  end
end
