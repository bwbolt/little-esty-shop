class MerchantBulkDiscountsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @discounts = @merchant.bulk_discounts
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    BulkDiscount.create(percentage: params[:percentage], threshold: params[:threshold],
                        merchant_id: params[:merchant_id])
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def destroy
    discount = BulkDiscount.find(params[:id])
    discount.destroy
    redirect_to merchant_bulk_discounts_path(params[:merchant_id])
  end

  def show
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def edit
    @merchant = Merchant.find(params[:merchant_id])
    @discount = BulkDiscount.find(params[:id])
  end

  def update
    discount = BulkDiscount.find(params[:id])
    merchant = Merchant.find(bulk_discount_params[:merchant_id])
    discount.update(bulk_discount_params)
    redirect_to merchant_bulk_discount_path(merchant, discount)
  end

  private

  def bulk_discount_params
    params.require(:bulk_discount).permit(:threshold, :percentage, :merchant_id)
  end
end
