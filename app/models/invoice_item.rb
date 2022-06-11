class InvoiceItem < ApplicationRecord
  enum status: { 'pending' => 0, 'packaged' => 1, 'shipped' => 2 }

  belongs_to :invoice
  belongs_to :item
  has_one :merchant, through: :item
  has_many :bulk_discounts, through: :merchant
  validates_presence_of :status

  before_create :add_discount

  def self.incomplete_inv
    where(status: %w[pending packaged])
      .order(:created_at)
  end

  def self.discounted_revenue
    distinct.map do |item|
      if !item.bulk_discount_id.nil?
        discount = BulkDiscount.find(item[:bulk_discount_id])
        item.quantity * item.unit_price * (100 - discount.percentage) / 100
      else
        item.quantity * item.unit_price
      end
    end.sum
  end

  private

  def add_discount
    bulk_discounts.order(threshold: :desc).each do |discount|
      self.bulk_discount_id = discount.id if quantity >= discount.threshold
    end
  end
end
