require_relative 'dashboard'

module API
  module V1
    module Admin
      class Base < Grape::API
        mount API::V1::Admin::Dashboard
      end
    end
  end
end
