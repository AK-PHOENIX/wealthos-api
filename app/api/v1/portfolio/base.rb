# frozen_string_literal: true

require_relative 'portfolios'

module API
  module V1
    module Portfolio
      # base api configurations for module
      class Base < Grape::API
        # helpers API::V1::Portfolio::Utils

        do_not_route_options!

        mount Portfolio::Portfolios
      end
    end
  end
end
