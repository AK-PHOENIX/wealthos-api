class BaseAPI < Grape::API
  prefix :api
  version 'v1', using: :path
  format :json
  content_type :json, 'application/json'

  helpers do
    def current_user
      token = headers['Authorization']&.split(' ')&.last
      return error!('Unauthorized', 401) unless token
      JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
      User.find(decoded['sub'])
    rescue
      error!('Unauthorized', 401)
    end

    def authenticate!
      current_user
    end
  end

  rescue_from ActiveRecord::RecordNotFound do |e|
    error!({ error: 'Not found', message: e.message }, 404)
  end

  rescue_from ActiveRecord::RecordInvalid do |e|
    error!({ error: 'Validation failed', message: e.message }, 422)
  end

  mount V1::AuthAPI
  mount V1::Portfolios
  mount V1::Holdings
  mount V1::Markets
  mount V1::Budget
  mount V1::Expenses
  mount V1::Alerts
  mount V1::AiAPI
end
