class BulkDiscount < ApplicationRecord
    validates :quantity, presence: true, numericality: true
    validates :discount, presence: true, numericality: true

    belongs_to :merchant
    has_many :items, through: :merchant
    has_many :invoice_items, through: :items
    has_many :invoices, through: :invoice_items
end