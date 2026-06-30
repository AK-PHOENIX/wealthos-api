module API
  module V1
    module Users
      class Me < Grape::API
        before { authenticate! }

        resource :me do
          desc 'Get current user details'
          get do
            {
              id: current_user.id,
              name: current_user.name,
              email: current_user.email,
              monthly_income: current_user.monthly_income.to_f,
              currency: current_user.currency || 'INR'
            }
          end

          desc 'Update current user details'
          params do
            requires :name, type: String
            requires :email, type: String
            optional :monthly_income, type: Float
            optional :currency, type: String
          end
          put do
            current_user.update!(
              name: params[:name],
              email: params[:email],
              monthly_income: params[:monthly_income],
              currency: params[:currency]
            )
            {
              id: current_user.id,
              name: current_user.name,
              email: current_user.email,
              monthly_income: current_user.monthly_income.to_f,
              currency: current_user.currency || 'INR'
            }
          end
        end
      end
    end
  end
end
