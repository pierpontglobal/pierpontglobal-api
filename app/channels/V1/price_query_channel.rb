# frozen_string_literal: true

# Manages the background task for admin
class PriceQueryChannel < ApplicationCable::Channel

  def subscribe; end

  def subscribed
    if current_user.has_role? :admin
      stream_from 'price_query_channel_admin'
    else
      stream_from "price_query_channel_#{current_user.id}"
    end
  end

  def update_status(params)
    params['mmr'] = params['mmr'].sub!('$', '').sub(',', '').to_i
    Car.find_by_vin(params['vin'])
       .update!(
         whole_price: params['mmr']
       )
  rescue => e
    params['mmr'] = 'null'
  ensure
    ActionCable.server.broadcast("price_query_channel_#{params['user']}",
                                 params.to_json)
  end

  def unsubscribe; end

  private

  def user_admin?
    unless current_user.has_role? :admin
      ActionCable
        .server
        .remote_connections
        .where(current_user: current_user)
        .disconnect
    end
  end
end
