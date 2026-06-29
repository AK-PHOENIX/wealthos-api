# frozen_string_literal: true

require_relative 'markets'

module API
  module V1
    module Market
      # base api configurations for module
      class Base < Grape::API
        # helpers API::V1::Market::Utils

        do_not_route_options!

        mount Market::Markets
      end
    end
  end
end
