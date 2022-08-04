class BulkDiscount < ApplicationRecord
    validates :quantity, presence: true, numericality: true
    validates :discount, presence: true, numericality: true

    belongs_to :merchant
end