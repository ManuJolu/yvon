class OrdersController < ApplicationController
  before_action :set_order, only: [:update]
  before_action :set_restaurant, only: [:index]

  def index
    @orders = policy_scope(@restaurant.orders).at_today
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
            ActionCable.server.broadcast "restaurant_orders_#{restaurant.id}",
              order_status: "handled"
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
        BotYvon::NotificationsController.new.notify_ready(@order) # if Rails.env.production?
        respond_to do |format|
          format.html { redirect_to @orders }
          format.js {
            ActionCable.server.broadcast "restaurant_orders_#{restaurant.id}",
              order_status: "ready"
          }
        end
      else
        respond_to do |format|
          format.html { render :index }
          format.js
        end
      end
    elsif order_params[:delivered_at]
      @order.delivered_at = DateTime.now
      if @order.save
        BotYvon::NotificationsController.new.notify_delivered(@order) # if Rails.env.production?
        respond_to do |format|
          format.html { redirect_to @orders }
          format.js {
            ActionCable.server.broadcast "restaurant_orders_#{restaurant.id}",
              order_status: "delivered"
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
    authorize restaurant, :update?
    @orders = restaurant.orders.at_today
    @delivered = (params[:order_status] == 'delivered' ? true : false)
    respond_to do |format|
      format.js
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
    authorize @order
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize @restaurant, :update?
  end

  def order_params
    params.require(:order).permit(:handled_at, :ready_at, :delivered_at)
  end
end


