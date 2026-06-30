class PriceCache < ApplicationRecord
  self.table_name = 'price_caches'

  validates :symbol, :asset_type, :price, presence: true
  validates :asset_type, inclusion: { in: %w[crypto stock mutual_fund] }
end
