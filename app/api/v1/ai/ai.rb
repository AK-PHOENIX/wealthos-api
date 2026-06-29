module V1
  class Ai < Grape::API
    before { authenticate! }

    resource :ai do

      params do
        requires :message, type: String
      end
      post :chat do
        portfolio_summary = current_user.portfolios.first&.holdings&.map do |h|
          "#{h.symbol}: bought at ₹#{h.buy_price}, current ₹#{h.current_price}, P&L #{h.pnl_percent.round(1)}%"
        end&.join(', ')

        expense_summary = current_user.expenses
                                      .where('expense_date >= ?', 30.days.ago)
                                      .group(:category)
                                      .sum(:amount)
                                      .map { |cat, amt| "#{cat}: ₹#{amt}" }
                                      .join(', ')

        context = <<~CONTEXT
          User portfolio: #{portfolio_summary || 'No holdings yet'}
          Last 30 days expenses by category: #{expense_summary || 'No expenses'}
          User monthly income: ₹#{current_user.monthly_income}
        CONTEXT

        response = AiService.chat(params[:message], context)
        { reply: response }
      end

    end
  end
end
