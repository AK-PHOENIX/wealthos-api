module API
  module V1
    module Users
      class Alerts < Grape::API
        before { authenticate! }

        resource :alerts do
          get do
            current_user.alerts.map do |a|
              {
                id: a.id,
                user_id: a.user_id,
                symbol: a.symbol,
                condition: a.condition,
                target_price: a.target_price.to_f,
                triggered: a.triggered,
                status: a.triggered ? 'Triggered' : 'Active',
                notified_at: a.notified_at
              }
            end
          end

          params do
            requires :symbol, type: String
            requires :condition, type: String, values: ->(v) { %w[above below].include?(v.downcase) }
            requires :target_price, type: Float
          end
          post do
            current_user.alerts.create!(
              symbol: params[:symbol],
              condition: params[:condition].downcase,
              target_price: params[:target_price],
              triggered: false
            )
          end

          route_param :id do
            delete do
              current_user.alerts.find(params[:id]).destroy
              { message: 'Deleted' }
            end
          end
        end
      end
    end
  end
end
