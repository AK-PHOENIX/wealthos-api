module API
  module V1
    module Users
      class Expenses < Grape::API
        before { authenticate! }

        resource :expenses do

          get do
            expenses = current_user.expenses
            expenses = expenses.where(category: params[:category]) if params[:category]
            expenses = expenses.where('expense_date >= ?', params[:from]) if params[:from]
            expenses.order(expense_date: :desc)
          end

          params do
            requires :amount, type: Float
            requires :description, type: String
            requires :expense_date, type: Date
            optional :category, type: String
            optional :ai_categorize, type: Boolean
          end
          post do
            category = params[:category]

            if params[:ai_categorize]
              category = AiService.categorize_expense(params[:description])
            end

            current_user.expenses.create!(
              amount: params[:amount],
              description: params[:description],
              expense_date: params[:expense_date],
              category: category || 'Other',
              ai_categorized: params[:ai_categorize] || false
            )
          end

          route_param :id do
            delete do
              current_user.expenses.find(params[:id]).destroy
              { message: 'Deleted' }
            end
          end

        end
      end
    end
  end
end
