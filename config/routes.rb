# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

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
        put '/reset_password', to: 'user#modify_password'
        patch '/reset_password', to: 'user#change_password'
        post '/send/phone_verification', to: 'user#send_phone_verification'
        post '/receive/phone_verification_state', to: 'user#is_phone_verified?'

        # Essential for 2FA
        namespace :token do
          post 'activate', to: 'tokens#activate'
          delete 'deactivate', to: 'tokens#deactivate'
        end

      end

      namespace :blacklist do
        get '/filters', to: 'filter#show'
        post '/filters', to: 'filter#create'
        delete '/filters', to: 'filter#destroy'
      end

      namespace :admin do
        post '/pulling/:state', to: 'cars#change_pulling'
      end

    end
  end
end