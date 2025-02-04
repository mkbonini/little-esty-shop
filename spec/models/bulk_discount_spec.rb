require 'rails_helper'

RSpec.describe BulkDiscount, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:quantity) }
    it { should validate_numericality_of(:quantity) }
    it { should validate_presence_of(:discount) }
    it { should validate_numericality_of(:discount) }
  end

  describe 'relationships' do
    it { should belong_to :merchant }
    it {should have_many(:items).through(:merchant)}
    it {should have_many(:invoice_items).through(:items)}
  end

  describe ' instance methods' do
  end
end