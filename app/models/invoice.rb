class Invoice < ApplicationRecord
  validates_presence_of :status,
                        :customer_id

  belongs_to :customer
  has_many :transactions
  has_many :invoice_items
  has_many :items, through: :invoice_items
  has_many :merchants, through: :items

  enum status: [:cancelled, :in_progress, :completed]

  def total_revenue
    invoice_items.sum("unit_price * quantity")
  end
  
  def discount_revenue
    invoice_items.joins("INNER JOIN items ON invoice_items.item_id = items.id
          INNER JOIN merchants ON items.merchant_id = merchants.id
          INNER JOIN bulk_discounts ON bulk_discounts.merchant_id = merchants.id")
          .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
          .sum("(bulk_discounts.percentage_discount * (invoice_items.unit_price * invoice_items.quantity)) / 100")

  end
end