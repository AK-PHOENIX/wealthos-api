# frozen_string_literal: true

require_relative 'expenses'

module API
  module V1
    module Users
      # base api configurations for module
      class Base < Grape::API
        # helpers API::V1::Users::Utils

        do_not_route_options!

        mount Users::Expenses
      end
    end
  end
end
