class ChangeDiscountToFloatInBulkDiscount < ActiveRecord::Migration[5.2]
  def change
    change_column :bulk_discounts, :discount, :float
  end
end
