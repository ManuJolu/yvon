class RestaurantChannel < ApplicationCable::Channel
  def subscribed
    stream_from "restaurant_#{params[:restaurant_id]}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
