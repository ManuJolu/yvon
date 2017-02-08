class OrdersController < ApplicationController
  before_action :set_order, only: [:update]
  before_action :set_restaurant, only: [:index]

  def index
    @orders = @restaurant.orders.at_week
  end

  def update
    @restaurant = @order.restaurant
    if order_params[:ready_at]
      @order.ready_at = DateTime.now
      if @order.save
        OrderView.new.notify_ready(@order) if Rails.env.production?
        respond_to do |format|
          format.html { redirect_to restaurant_path(@restaurant) }
          format.js { @ready = true }
        end
      else
        @meal = @restaurant.meals.new
        respond_to do |format|
          format.html { render 'restaurants/show' }
          format.js
        end
      end
    elsif order_params[:delivered_at]
      @order.update(delivered_at: Time.now)
      if @order.save
        OrderView.new.notify_delivered(@order) if Rails.env.production?
        respond_to do |format|
          format.html { redirect_to restaurant_path(@restaurant) }
          format.js { }
        end
      else
        @meal = @restaurant.meals.new
        respond_to do |format|
          format.html { render 'restaurants/show' }
          format.js { }
        end
      end
    end
  end

  def pending
    @restaurant = Restaurant.find(params[:restaurant_id])
    respond_to :js
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def order_params
    params.require(:order).permit(:ready_at, :delivered_at)
  end



end


