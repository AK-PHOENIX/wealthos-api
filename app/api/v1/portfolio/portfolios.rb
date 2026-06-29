module V1
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
              current_price: h.current_price,
              pnl: h.pnl,
              pnl_percent: h.pnl_percent.round(2)
            }
          end
          { portfolio: portfolio, holdings: holdings }
        end

        delete do
          current_user.portfolios.find(params[:id]).destroy
          { message: 'Deleted' }
        end
      end

    end
  end
end
