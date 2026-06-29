class Holding < ApplicationRecord
  belongs_to :portfolio
  has_many :transactions, dependent: :destroy

  validates :symbol, :asset_type, :quantity, :buy_price, presence: true
  validates :asset_type, inclusion: { in: %w[crypto stock mutual_fund] }

  def current_price
    PriceCache.find_by(symbol: symbol)&.price || buy_price
  end

  def pnl
    (current_price - buy_price) * quantity
  end

  def pnl_percent
    ((current_price - buy_price) / buy_price) * 100
  end
end
