# frozen_string_literal: true
require_relative 'ai'
module API
  module V1
    module Ai
      class Base < Grape::API
        do_not_route_options!
        mount API::V1::Ais::Ai
      end
    end
  end
end
