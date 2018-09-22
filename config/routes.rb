# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
  end

  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      get '/version', to: 'base#version'

      devise_for :users, controllers: {
          registrations: 'api/v1/user/registrations',
      }, skip: [:sessions, :password]

      namespace :user do
        get '/me', to: 'user#me'
      end
    end
  end
end
