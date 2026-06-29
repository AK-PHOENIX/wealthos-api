require_relative 'v1/base'

module API
  class Base < Grape::API
    PREFIX = '/api'

    cascade false

    mount API::V1::Base => API::V1::Base::API_VERSION
  end
end
