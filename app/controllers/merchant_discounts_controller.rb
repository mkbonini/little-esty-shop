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
        merchant.items.new(discount_params)
    
        if merchant.save
          redirect_to merchant_discount_path(merchant)
          flash[:notice] = "Item successfully created!"
        else
          redirect_to new_merchant_discount_path(merchant)
          flash[:alert] = "Error: Please fill in all fields."
        end
    end
end