# frozen_string_literal: true

require_relative 'expenses'
require_relative 'budgets'
require_relative 'alerts'
require_relative 'me'

module API
  module V1
    module Users
      # base api configurations for module
      class Base < Grape::API
        # helpers API::V1::Users::Utils

        do_not_route_options!

        mount Users::Expenses
        mount Users::Budgets
        mount Users::Alerts
        mount Users::Me
      end
    end
  end
end
