class Invoice < ApplicationRecord
  validates_presence_of :status, presence: true

  belongs_to :customer
  
  has_many :transactions, dependent: :destroy
  has_many :invoice_items, dependent: :destroy
  has_many :items, through: :invoice_items
  has_many :bulk_discounts, through: :invoice_items

  enum status: { "in progress": 0, "completed": 1, "cancelled": 2 }


  def self.incomplete_invoices
    joins(:invoice_items)
    .where.not(invoice_items: {status: 'shipped'})
    .distinct
    .order("created_at")
  end

  def total_revenue
    revenue_generated = 0
    invoice_items.each do |invoice_item|
      revenue_generated += (invoice_item.quantity * invoice_item.unit_price)
    end
    revenue_generated
  end

  def discount_revenue
    discount = invoice_items.joins(:bulk_discounts)
    .where("invoice_items.quantity >= bulk_discounts.quantity")
    .select('invoice_items.*, bulk_discounts.*, (invoice_items.quantity * invoice_items.unit_price * bulk_discounts.discount) as discounted_revenue, bulk_discounts.id as discount_id')
    .order('bulk_discounts.discount DESC')

    total_revenue - (discount.uniq.sum(&:discounted_revenue))
  end
end