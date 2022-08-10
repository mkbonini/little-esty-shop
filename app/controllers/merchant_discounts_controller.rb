class MerchantDiscountsController < ApplicationController
    def index
        @merchant = Merchant.find(params[:merchant_id])
        @search = HolidaySearch.new
    end

    def show
        @facade = discount_objects
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

    def edit
      @facade = discount_objects
    end

    def update
      discount = BulkDiscount.find(params[:id])
      if discount.update(discount_params)
        flash[:notice] = "Item successfully updated!"
        redirect_to merchant_discount_path(discount.merchant, discount)
      else
        flash[:alert] = "Error: Please fill in all fields."
        redirect_to edit_merchant_discount_path(discount.merchant, discount)
      end
    end

    def destroy
      discount = BulkDiscount.delete(params[:id])
      redirect_to merchant_discounts_path(params[:merchant_id])
    end

    private
    def discount_params
      params.permit(:quantity, :discount)
    end

    def discount_objects
      @discount = BulkDiscount.find(params[:id])
      @merchant = Merchant.find(params[:merchant_id])
    end
end