class BulkDiscountsController < ApplicationController 
  before_action :find_bulk_discount_and_merchant, only: [:show, :edit, :update, :destroy]
  before_action :find_merchant, only: [:new, :create]
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
   
  end

  def create
    BulkDiscount.create!(percentage_discount: params[:percentage_discount],
    quantity_threshold: params[:quantity_threshold],
    merchant: @merchant)

    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    if @bulk_discount.update(bulk_discount_params)
      # flash.notice = "Succesfully Updated bulk_discount Info!"
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash.notice = "All fields must be completed, get your act together."
      render :edit
    end
  end

  def destroy
    bulk_discount = BulkDiscount.find(params[:id])
    bulk_discount.destroy 

    redirect_to merchant_bulk_discounts_path(@merchant)
  end


  private
  def bulk_discount_params
    params.require(:bulk_discount).permit(:percentage_discount, :quantity_threshold)
  end

  def find_bulk_discount_and_merchant
    @bulk_discount = BulkDiscount.find(params[:id])
    @merchant = Merchant.find(params[:merchant_id])
  end

  def find_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end
end