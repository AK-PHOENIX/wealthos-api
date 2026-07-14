module API
  module V1
    module Admin
      class Dashboard < Grape::API
        before { authenticate! }

        resource :dashboard do
          get do
            # 1. Fetch Holdings and Transactions (from the first portfolio)
            portfolio = current_user.portfolios.includes(holdings: :transactions).first
            
            holdings_data = []
            transactions_data = []

            if portfolio
              holdings_data = portfolio.holdings.map do |h|
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

              transactions_data = Transaction.where(holding_id: portfolio.holdings.pluck(:id))
                                             .order(transaction_date: :desc)
                                             .limit(50)
                                             .map do |t|
                {
                  id: t.id,
                  symbol: t.holding.symbol,
                  type: t.transaction_type.capitalize,
                  quantity: t.quantity.to_f,
                  price: t.price.to_f,
                  date: t.transaction_date.to_s
                }
              end
            end

            # 2. Fetch Budgets
            budgets_data = current_user.budget_goals.map do |b|
              spent = current_user.expenses
                                  .where(category: b.category)
                                  .where('expense_date >= ? AND expense_date <= ?', Date.today.beginning_of_month, Date.today.end_of_month)
                                  .sum(:amount)
              {
                id: b.id,
                user_id: b.user_id,
                category: b.category,
                monthly_limit: b.monthly_limit.to_f,
                limit: b.monthly_limit.to_f,
                month: b.month,
                year: b.year,
                spent: spent.to_f
              }
            end

            # Return consolidated response
            {
              holdings: holdings_data,
              transactions: transactions_data,
              budgets: budgets_data
            }
          end
        end
      end
    end
  end
end
