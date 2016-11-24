class OrdersController < ApplicationController
  before_action :find_restaurant, only: [ :index, :show, :edit, :update ]
  before_action :find_order, only: [ :edit, :update ]

  def index
    @orders = @restaurant.orders.all
  end

  def show
  end

  def edit
  end

  def update
    @order.update(order_params)
    @order.save
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:ready_at, :delete_at)
  end

end


