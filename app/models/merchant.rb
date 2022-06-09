class Merchant < ApplicationRecord
  enum status: { 'Enabled' => 0, 'Disabled' => 1 }
  validates_presence_of :name
  has_many :items, dependent: :destroy
  has_many :invoice_items, through: :items, dependent: :destroy
  has_many :invoices, through: :invoice_items, dependent: :destroy
  has_many :customers, through: :invoices, dependent: :destroy
  has_many :transactions, through: :invoices, dependent: :destroy
  has_many :bulk_discounts

  def fave_customers
    customers.joins(invoices: :transactions)
             .where(transactions: { result: 0 })
             .select('customers.*, count(transactions.result) as transaction_total')
             .group(:id)
             .order(transaction_total: :desc)
             .distinct
             .limit(5)
  end

  def unshipped_items
    invoice_items.joins(:invoice).where(status: 1).order('invoices.created_at')
  end

  def self.top_five_merchants
    joins(invoices: %i[transactions invoice_items])
      .where(invoices: { status: 2 })
      .select('merchants.* , sum(invoice_items.unit_price * invoice_items.quantity) AS total_revenue')
      .group(:id)
      .order(total_revenue: :desc)
      .limit(5)
  end

  def best_day
    invoices.best_day
  end
end
