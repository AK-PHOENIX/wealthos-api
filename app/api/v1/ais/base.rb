# frozen_string_literal: true

require_relative 'ai'

module API
  module V1
    module Ai
      # base api configurations for module
      class Base < Grape::API
        # helpers API::V1::Ai::Utils

        do_not_route_options!

        mount Ais::Ai
      end
    end
  end
end
