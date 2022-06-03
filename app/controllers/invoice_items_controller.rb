class InvoiceItemsController < ApplicationController
  def update
    @merchant = Merchant.find(params[:merchant_id])
    @invoice = Invoice.find(params[:id])
    @invoice_item = InvoiceItem.find(params[:invoice_id])
    if params[:status] == "pending"
      @invoice_item.update!(status: 0)
    elsif params[:status] == "packaged"
      @invoice_item.update!(status: 1)
    elsif params[:status] == "shipped"
      @invoice_item.update!(status: 2)
    end
    redirect_to merchant_invoice_path(@merchant, @invoice)
  end
end
