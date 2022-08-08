class MerchantDiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
    end

    def show
        @discount = BulkDiscount.find(params[:id])
    end
    
    def new
        @merchant = Merchant.find(params[:merchant_id])
    end

    def create
        merchant = Merchant.find(params[:merchant_id])
        merchant.bulk_discounts.new(discount_params)
    
        if merchant.save
          redirect_to merchant_discounts_path(merchant)
          flash[:notice] = "Item successfully created!"
        else
          redirect_to new_merchant_discount_path(merchant)
          flash[:alert] = "Error: Please fill in all fields."
        end
    end

    def destroy
      @discount = BulkDiscount.delete(params[:id])
      redirect_to merchant_discounts_path(params[:merchant_id])
    end

    private
    def discount_params
      params.permit(:quantity, :discount)
    end
end