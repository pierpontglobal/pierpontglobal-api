# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
    controllers tokens: 'logger'
  end

  # Allow rswag to set the routes for the auto generated documentation.
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Relative to the routes that belongs to the API
  namespace :api do
    # Relative to the routes that belongs to the version 1 of the API
    namespace :v1 do

      devise_for :users, controllers: {
        registrations: 'api/v1/user/registrations',
        confirmations: 'api/v1/user/confirmations'
      }, skip: %i[sessions password]

      namespace :user do
        get '/me', to: 'user#me'
        patch '/me', to: 'user#modify_user'
        patch '/me/address', to: 'user#modify_address'
      end
    end
  end
end
