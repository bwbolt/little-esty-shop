class Invoice < ApplicationRecord
  enum status: { 'in progress' => 0, 'cancelled' => 1, 'completed' => 2 }

  belongs_to :customer
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items
  has_many :bulk_discounts, through: :merchants
  has_many :transactions

  validates_presence_of :status

  def total_revenue
    invoice_items.sum('quantity * unit_price')
  end

  def self.best_day
    joins(:invoice_items)
      .where(status: 2)
      .select('invoices.created_at, max(invoice_items.unit_price * invoice_items.quantity) as best_day')
      .group(:created_at)
      .order(best_day: :desc)
      .first
  end

  def discounted_revenue
    invoice_items.discounted_revenue
  end
end
