class InvoiceItem < ApplicationRecord
  validates_presence_of :invoice_id,
                        :item_id,
                        :quantity,
                        :unit_price,
                        :status

  belongs_to :invoice
  belongs_to :item

  enum status: [:pending, :packaged, :shipped]

  def self.incomplete_invoices
    invoice_ids = InvoiceItem.where("status = 0 OR status = 1").pluck(:invoice_id)
    Invoice.order(created_at: :asc).find(invoice_ids)
  end

  def bulk_connect 
    merchant = item.merchant
    BulkDiscount.joins(:merchant)
                .where("bulk_discounts.quantity_threshold <= ?", quantity)
                .where(merchants: { id: merchant.id })
                .first
  end
end
# joins(:item)
#   .joins("INNER JOIN merchants ON items.merchant_id = merchants.id")
#   .joins("INNER JOIN bulk_discounts ON bulk_discounts.merchant_id = merchants.id")
#   .where("invoice_items.quantity >= bulk_discounts.quantity_threshold")
#   .exists?



# invoice_items.joins("INNER JOIN items ON invoice_items.item_id = items.id
#               INNER JOIN merchants ON items.merchant_id = merchants.id
#               INNER JOIN bulk_discounts ON bulk_discounts.merchant_id = merchants.id")
#               .where("invoice_items.quantity >= 100")
#               .pluck