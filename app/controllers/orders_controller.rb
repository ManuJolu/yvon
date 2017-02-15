class OrdersController < ApplicationController
  before_action :set_order, only: [:update]
  before_action :set_restaurant, only: [:index]

  def index
    @orders = @restaurant.orders.at_today
  end

  def update
    restaurant = @order.restaurant
    @orders = restaurant.orders.at_today
    if order_params[:handled_at]
      @order.handled_at = DateTime.now
      if @order.save
        respond_to do |format|
          format.html { redirect_to @orders }
          format.js {
            ActionCable.server.broadcast "restaurant_#{restaurant.id}",
              order_id: @order.id, delivered: false
          }
        end
      else
        respond_to do |format|
          format.html { render :index }
          format.js
        end
      end
    elsif order_params[:ready_at]
      @order.ready_at = DateTime.now
      if @order.save
        OrderView.new.notify_ready(@order) if Rails.env.production?
        respond_to do |format|
          format.html { redirect_to @orders }
          format.js {
            ActionCable.server.broadcast "restaurant_#{restaurant.id}",
              order_id: @order.id, delivered: false
          }
        end
      else
        respond_to do |format|
          format.html { render :index }
          format.js
        end
      end
    elsif order_params[:delivered_at]
      @order.update(delivered_at: Time.now)
      if @order.save
        OrderView.new.notify_delivered(@order) if Rails.env.production?
        respond_to do |format|
          format.html { redirect_to @orders }
          format.js {
            ActionCable.server.broadcast "restaurant_#{restaurant.id}",
              order_id: @order.id, delivered: true
          }
        end
      else
        respond_to do |format|
          format.html { render :index }
          format.js
        end
      end
    end
  end

  def refresh
    restaurant = Restaurant.find(params[:id])
    @orders = restaurant.orders.at_today
    @delivered = (params[:delivered] == "true" ? true : false)
    respond_to do |format|
      format.js
    end
  end



  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def order_params
    params.require(:order).permit(:handled_at, :ready_at, :delivered_at)
  end
end


