# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
@merchant = Merchant.create!(name: 'Brylan')
@discount1 = @merchant.bulk_discounts.create(threshold: 3, percentage: 10)
@discount2 = @merchant.bulk_discounts.create(threshold: 5, percentage: 15)
@item_1 = @merchant.items.create!(name: 'Pencil', unit_price: 500, description: 'Writes things.')
@item_2 = @merchant.items.create!(name: 'Pen', unit_price: 400, description: 'Writes things, but dark.')
@item_3 = @merchant.items.create!(name: 'Marker', unit_price: 400,
                                  description: 'Writes things, but dark, and thicc.')

@customer_1 = Customer.create!(first_name: 'Joey', last_name: 'Ondricka')
@invoice_1 = @customer_1.invoices.create!(status: 'completed',
                                          created_at: 'Wed, 01 Jan 2022 21:20:02 UTC +00:00')
@invoice_7 = @customer_1.invoices.create!(status: 'completed')
@invoice_item_1 = @item_1.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 3, unit_price: 400, status: 'packaged',
                                                created_at: Time.parse('2012-03-27 14:54:09 UTC'))
@invoice_item_2 = @item_2.invoice_items.create!(invoice_id: @invoice_7.id, quantity: 5, unit_price: 375, status: 'pending',
                                                created_at: Time.parse('2012-03-28 14:54:09 UTC'))
@invoice_item_3 = @item_2.invoice_items.create!(invoice_id: @invoice_1.id, quantity: 1, unit_price: 375, status: 'shipped',
                                                created_at: Time.parse('2012-03-28 14:54:09 UTC'))
