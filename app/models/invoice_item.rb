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
      item.calculated_cost
    end.sum
  end

  def calculated_cost
    if !bulk_discount_id.nil?
      discount = BulkDiscount.find(bulk_discount_id)
      quantity * unit_price * (100 - discount.percentage) / 100
    else
      quantity * unit_price
    end
  end

  private

  def add_discount
    bulk_discounts.order(threshold: :desc).each do |discount|
      if quantity >= discount.threshold
        self.bulk_discount_id = discount.id
        break
      end
    end
  end
end
