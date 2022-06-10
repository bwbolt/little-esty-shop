class BulkDiscount < ApplicationRecord
  validates_presence_of :threshold, :percentage, :merchant_id

  belongs_to :merchant
end
