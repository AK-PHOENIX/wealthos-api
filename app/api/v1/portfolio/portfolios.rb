module API
  module V1
    module Portfolio
      class Portfolios < Grape::API
        before { authenticate! }

        resource :portfolios do

          get do
            current_user.portfolios.includes(holdings: :transactions)
          end

          post do
            current_user.portfolios.create!(name: params[:name])
          end

          route_param :id do
            get do
              portfolio = current_user.portfolios.find(params[:id])
              holdings = portfolio.holdings.map do |h|
                {
                  id: h.id,
                  symbol: h.symbol,
                  asset_type: h.asset_type,
                  quantity: h.quantity,
                  buy_price: h.buy_price,
                  buy_date: h.buy_date,
                  current_price: h.current_price,
                  pnl: h.pnl,
                  pnl_percent: h.pnl_percent.round(2)
                }
              end
              transactions = Transaction.where(holding_id: portfolio.holdings.pluck(:id)).order(transaction_date: :desc).map do |t|
                {
                  id: t.id,
                  symbol: t.holding.symbol,
                  type: t.transaction_type.capitalize,
                  quantity: t.quantity.to_f,
                  price: t.price.to_f,
                  date: t.transaction_date.to_s
                }
              end
              { portfolio: portfolio, holdings: holdings, transactions: transactions }
            end

            delete do
              current_user.portfolios.find(params[:id]).destroy
              { message: 'Deleted' }
            end

            resource :holdings do
              desc 'Add holding'
              params do
                requires :symbol, type: String
                requires :asset_type, type: String
                requires :quantity, type: Float
                requires :buy_price, type: Float
                optional :buy_date, type: Date
              end
              post do
                portfolio = current_user.portfolios.find(params[:id])
                holding = portfolio.holdings.create!(
                  symbol: params[:symbol],
                  asset_type: params[:asset_type],
                  quantity: params[:quantity],
                  buy_price: params[:buy_price],
                  buy_date: params[:buy_date] || Date.today
                )
                holding.transactions.create!(
                  transaction_type: 'buy',
                  quantity: params[:quantity],
                  price: params[:buy_price],
                  transaction_date: params[:buy_date] || Date.today
                )
                PriceCache.find_or_create_by!(symbol: params[:symbol], asset_type: params[:asset_type]) do |pc|
                  pc.price = params[:buy_price]
                end
                holding
              end

              route_param :holding_id do
                desc 'Delete holding'
                delete do
                  portfolio = current_user.portfolios.find(params[:id])
                  portfolio.holdings.find(params[:holding_id]).destroy
                  { message: 'Deleted' }
                end
              end
            end
          end

        end
      end
    end
  end
end
