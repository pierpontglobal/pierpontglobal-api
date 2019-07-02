# frozen_string_literal: true

Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => "/sidekiq"
  mount ActionCable.server => '/cable'

  devise_for :users,
             path: '/api/v2/users',
             path_names: {
                 sign_in: 'login',
                 sign_out: 'logout',
                 registration: 'signup'
             },
             controllers: {
                 sessions: 'api/v2/users/sessions',
                 registrations: 'api/v2/users/registrations'
             }

  # Relative to the routes that belongs to the API
  namespace :api do
    # Relative to the routes that belongs to the version 1 of the API
    namespace :v1 do

      get '/aws-health', to: 'user_base#health'

      devise_for :users, controllers: {
        registrations: 'api/v1/user/registrations',
        confirmations: 'api/v1/user/confirmations'
      }, skip: %i[sessions password]

      namespace :user do
        post '/photo', to: 'user#set_profile_photo'

        get '/settings', to: 'user#settings'

        post '/payment/status', to: 'user#send_payment_status'

        get '/', to: 'user#info'

        post '/notifier', to: 'user#register_notifier'
        delete '/notifier', to: 'user#deregister_notifier'

        patch '/', to: 'user#modify_user'
        patch '/address', to: 'user#modify_address'
        post '/resend-confirmation', to: 'user#resend_confirmation'

        post '/send-contact-form', to: 'user#send_contact_form'

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
        post '/verify', to: 'user#verify_user'

        get '/saved_cars', to: 'user#saved_cars'

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
          post '/logo', to: 'dealers#set_photo'
        end

        namespace :cards do
          get '/', to: 'cards#card_sources'
          get '/default', to: 'cards#default_card_source'
          get '/coupon', to: 'cards#coupon'
          post '/', to: 'cards#card_registration'
          post '/append', to: 'cards#append_card'
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
        post '/save', to: 'cars#save_vehicle'
        delete '/delete', to: 'cars#remove_user_vehicle'

        get '/bid', to: 'bids#show'
        post '/bid', to: 'bids#increase_bid'
        patch '/bid', to: 'bids#modify_bid'
        delete '/bid', to: 'bid#deactivate_bid'
      end

      namespace :blacklist do
        get '/filters', to: 'filter#show'
        post '/filters', to: 'filter#create'
        delete '/filters', to: 'filter#destroy'
      end

      namespace :notification do
        get '/', to: 'notifications#show_by_current_user'
        post '/read', to: 'notifications#read_notification'
        post '/read_all', to: 'notifications#read_all'
        post '/', to: 'notifications#add_notification_to_current_user'
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

        namespace :administrator do
          get '/', to: 'administrators#show'
          get '/logs', to: 'administrators#show_logs'
        end

        namespace :bid do
          get '/', to: 'bid#show_bid'
          get '/all', to: 'bid#show_bids'
          get '/collectors', to: 'bid#bid_collector'
          get '/collectors/:bid_collector_id', to: 'bid#bid_details'
          delete '/', to: 'bid#delete_bid'
          patch '/', to: 'bid#change_bid_status'
          patch '/success', to: 'bid#notify_success'
          patch '/submitted', to: 'bid#flag_submitted'
        end

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

        namespace :user do
          get '/', to: 'users#show_all'
          get '/single', to: 'users#show'
          post '/email', to: 'users#send_email'
          post '/email/direct', to: 'users#send_direct_email'
        end

        resource :locations
      end
    end

    namespace :v2 do
      namespace :users do
        post '/subscription', to: 'users#subscribe'
        post '/recover', to: 'recover#send_recover_email'
        post '/password_change', to: 'recover#reset_password'
      end
      namespace :heavy_vehicles do
        get '/', to: 'heavy_vehicles#show'
      end
    end
  end
end