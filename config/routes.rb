# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"

  use_doorkeeper do
    skip_controllers :applications, :authorized_applications
    controllers tokens: 'logger'
  end

  mount ActionCable.server => '/cable'

  # Relative to the routes that belongs to the API
  namespace :api do
    # Relative to the routes that belongs to the version 1 of the API
    namespace :v1 do

      get '/aws-health', to: 'base#health'

      devise_for :users, controllers: {
        registrations: 'api/v1/user/registrations',
        confirmations: 'api/v1/user/confirmations'
      }, skip: %i[sessions password]

      namespace :user do

        post '/payment/status', to: 'user#send_payment_status'

        get '/', to: 'user#info'
        patch '/', to: 'user#modify_user'
        patch '/address', to: 'user#modify_address'
        post '/resend-confirmation', to: 'user#resend_confirmation'

        post '/invalidate', to: 'user#log_out'

        put '/images', to: 'user#add_image'
        delete '/images', to: 'user#remove_image'

        put '/reset_password', to: 'user#modify_password'
        patch '/reset_password', to: 'user#change_password'

        post '/send/phone_verification', to: 'user#send_phone_verification'
        post '/receive/phone_verification_state', to: 'user#phone_verified?'

        get '/availability', to: 'user#verify_availability'
        get '/subscription', to: 'user#return_subscribed_info'
        post '/subscription', to: 'user#subscribe'

        namespace :funds do
          get '/', to: 'funds#show_funds'
          get '/history', to: 'funds#funds_transactions'
          post '/', to: 'funds#add_funds'
        end

        namespace :bids do
          get '/', to: 'bids#show'
        end

        namespace :transactions do
          get '/manual-history', to: 'transactions#show_manual_transactions'
        end

        namespace :dealers do
          get '/', to: 'dealers#retrieve_dealer'
          post '/', to: 'dealers#create_dealer'
          patch '/', to: 'dealers#update_dealer'
        end

        namespace :cards do
          get '/', to: 'cards#card_sources'
          get '/default', to: 'cards#default_card_source'
          post '/', to: 'cards#card_registration'
          patch '/default', to: 'cards#change_default_card_source'
          delete '/', to: 'cards#remove_card'
        end

        namespace :subscriptions do
          get '/', to: 'subscriptions#current_subscription'
          get '/view', to: 'subscriptions#subscription_view'
          get '/payments', to: 'subscriptions#retrieve_payments'
          post '/attach', to: 'subscriptions#attach_subscription'
          post '/payment', to: 'subscriptions#payment'
          patch '/renew', to: 'subscriptions#modify_renew_status'
        end

        # Essential for 2FA
        namespace :token do
          post '/activate', to: 'tokens#activate'
          delete '/deactivate', to: 'tokens#deactivate'
        end
      end

      namespace :car do
        get '/', to: 'cars#show'
        get '/latest', to: 'cars#latest'
        get '/all', to: 'cars#all'
        get '/query', to: 'cars#query'
        patch '/price-request', to: 'cars#price_request'

        get '/bid', to: 'bids#show'
        post '/bid', to: 'bids#increase_bid'
      end

      namespace :blacklist do
        get '/filters', to: 'filter#show'
        post '/filters', to: 'filter#create'
        delete '/filters', to: 'filter#destroy'
      end

      namespace :admin do
        post '/pulling/:state', to: 'cars#change_pulling'
        post '/cars/clean', to: 'cars#clean_cars'
        post '/cars/reindex', to: 'cars#reindex'

        # Users manager
        patch '/users/block', to: 'users#block'
        patch '/users/unblock', to: 'users#unblock'

        # Risk notices
        get '/users/notices', to: 'users#maxmind_notice'
        get '/users/notices/:status', to: 'users#maxmind_notices'
        patch '/users/notices/resolve', to: 'users#resolve_maxmind'
        put '/users/notices/status', to: 'users#risk_notice_status'

        # Configurations
        get '/configuration/register_ip', to: 'configuration#register_ip'

        resource :step_groups do
          get 'all', to: 'step_groups#all'
        end

        resource :step_logs do
          get '/acquisition/all', to: 'step_logs#all_from_adquisition'
        end

        scope :funds do
          post '/', to: 'funds#add_funds'
          delete '/', to: 'funds#remove_funds'
          get '/', to: 'funds#show_funds'
        end

        scope :transactions do
          post '/', to: 'transactions#create_transaction'
          delete '/', to: 'transactions#remove_transaction'
        end

        resource :locations
      end
    end
  end
end