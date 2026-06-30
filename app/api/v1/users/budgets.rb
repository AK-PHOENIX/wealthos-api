module API
  module V1
    module Users
      class Budgets < Grape::API
        before { authenticate! }

        resource :budgets do
          get do
            current_user.budget_goals.map do |b|
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
          end

          params do
            requires :category, type: String
            optional :monthly_limit, type: Float
            optional :limit, type: Float
            optional :month, type: Integer, default: Date.today.month
            optional :year, type: Integer, default: Date.today.year
          end
          post do
            limit = params[:limit] || params[:monthly_limit]
            error!('limit or monthly_limit is required', 400) unless limit
            current_user.budget_goals.create!(
              category: params[:category],
              monthly_limit: limit,
              month: params[:month],
              year: params[:year]
            )
          end

          route_param :id do
            params do
              optional :monthly_limit, type: Float
              optional :limit, type: Float
            end
            put do
              budget = current_user.budget_goals.find(params[:id])
              limit = params[:limit] || params[:monthly_limit]
              error!('limit or monthly_limit is required', 400) unless limit
              budget.update!(monthly_limit: limit)
              {
                id: budget.id,
                user_id: budget.user_id,
                category: budget.category,
                monthly_limit: budget.monthly_limit.to_f,
                limit: budget.monthly_limit.to_f,
                month: budget.month,
                year: budget.year
              }
            end
          end
        end
      end
    end
  end
end
