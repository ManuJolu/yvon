class RestaurantOrdersChannel < ApplicationCable::Channel
  def subscribed
    stream_from "restaurant_orders_#{params[:restaurant_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
