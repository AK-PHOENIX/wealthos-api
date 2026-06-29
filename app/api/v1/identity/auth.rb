module API
  module V1
    module Identity
      class Auth < Grape::API
        resource :auth do

          desc 'Register'
          params do
            requires :email, type: String
            requires :password, type: String
            requires :name, type: String
            optional :monthly_income, type: Float
          end
          post :signup do
            user = User.create!(
              email: params[:email],
              password: params[:password],
              name: params[:name],
              monthly_income: params[:monthly_income]
            )
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
            { token: token, user: { id: user.id, name: user.name, email: user.email } }
          end

          desc 'Login'
          params do
            requires :email, type: String
            requires :password, type: String
          end
          post :login do
            user = User.find_by(email: params[:email])
            error!('Invalid credentials', 401) unless user&.valid_password?(params[:password])
            token = Warden::JWTAuth::UserEncoder.new.call(user, :user, nil).first
            { token: token, user: { id: user.id, name: user.name, email: user.email } }
          end

        end
      end
    end
  end
end
