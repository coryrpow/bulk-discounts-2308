class BulkDiscountsController < ApplicationController 

  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    find_merchant
  end

  def create
    find_merchant
    BulkDiscount.create!(percentage_discount: params[:percentage_discount],
    quantity_threshold: params[:quantity_threshold],
    merchant: @merchant)

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def destroy
    find_merchant
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy 
    redirect_to merchant_bulk_discounts_path(@merchant)
  end


  private
  def bulk_discount_params
    params.permit(:percentage_discount)
  end

  def find_bulk_discount_and_merchant
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end