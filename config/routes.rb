require_relative "../app/api/base"

Rails.application.routes.draw do
  devise_for :users
  mount API::Base => '/'
end
