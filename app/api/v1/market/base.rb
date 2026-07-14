# frozen_string_literal: true
require_relative 'markets'
require_relative 'rates'
module API
  module V1
    module Market
      class Base < Grape::API
        do_not_route_options!
        mount Market::Markets
        mount Market::Rates
      end
    end
  end
end
