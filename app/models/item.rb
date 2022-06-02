
class Item < ApplicationRecord 
  enum status: { 'Enabled' => 0, 'Disabled' => 1 }
  
  belongs_to :merchant
  has_many :invoice_items
  has_many :invoices, through: :invoice_items
  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price
  has_many :items, through: :invoice_items

  def unit_price_to_dollars
    unit_price.to_s.rjust(3, "0").insert(-3, ".")
  end

  def self.most_popular_items
    joins(invoice_items: [:invoice]).where(invoices: {status: 2}).select("items.*, sum(invoice_items.quantity * invoice_items.unit_price)").group(:id).order(sum: :desc).limit(5).to_a
  end

  def total_item_revenue
    # invoice_items.sum("quantity * unit_price").to_f / 100
    invoice_items.sum("quantity * unit_price").to_s.rjust(3, "0").insert(-3, ".")
  end 
end
