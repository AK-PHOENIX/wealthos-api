# frozen_string_literal: true

require_relative 'auth'

module API
  module V1
    module Identity
      # base api configurations for module
      class Base < Grape::API
        # helpers API::V1::Identity::Utils

        do_not_route_options!

        # mount Identity::General
        mount Identity::Auth
        # mount Identity::Users
        # mount Identity::Redfog
      end
    end
  end
end
