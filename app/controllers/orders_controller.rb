class OrdersController < ApplicationController
  before_action :find_restaurant, only: [ :index, :show, :edit, :update ]
  def index
    @orders = @restaurant.orders.all
  end

  def show
  end

  def edit
  end

  def update
  end

  private

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
