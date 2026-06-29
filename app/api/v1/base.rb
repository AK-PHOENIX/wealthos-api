# frozen_string_literal: true

require_relative 'identity/base'
require_relative 'market/base'
require_relative 'ais/base'
require_relative 'portfolio/base'
require_relative 'users/base'

module API
  module V1
    class Base < Grape::API
      API_VERSION = 'v1'


      format :json
      content_type :json, 'application/json'
      default_format :json

      mount API::V1::Identity::Base   => '/identity'
      mount API::V1::Market::Base     => '/market'
      mount API::V1::Ai::Base         => '/ai'
      mount API::V1::Portfolio::Base  => '/portfolio'
      mount API::V1::Users::Base      => '/users'

      route :any, '*path' do
        error!({ error: 'Route not found' }, 404)
      end
    end
  end
end
