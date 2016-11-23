class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:show, :edit, :update]

  def index
    @restaurants = Restaurant.all
  end

  def show
    @meal = @restaurant.meals.new
    @orders = @restaurant.orders

  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    # pundit approval
    # authorize @restaurant
    # @restaurant = Restaurant.new(restaurant_params)
    # @restaurant.user = current_user
    if @restaurant.save
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    @restaurant.update(restaurant_params)
    if restaurant.save
      redirect_to @restaurant
    else
      render 'edit'
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
  end

  def restaurant_params
    params.require(:restaurant).permit(:name, :user_id, :address, :category, :on_duty, :shift, :photo, :description)
  end

end
