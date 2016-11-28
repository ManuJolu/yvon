class MealsController < ApplicationController
  before_action :set_meal, only: [:update]
  before_action :set_restaurant, only: [:create, :update]

  def create
    @meal = @restaurant.meals.new(meal_params)
    if @meal.save
      redirect_to @restaurant
    else
      @orders = @restaurant.orders
      render 'restaurants/show'
    end
  end

  def update
    @meal.update(meal_params)
    if meal.save
      redirect_to @restaurant
    else
      render 'edit'
    end
  end

  private

  def set_meal
    @meal = Meal.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def meal_params
    params.require(:meal).permit(:restaurant_id, :category, :name, :description, :price, :tax_rate, :photo)
  end

end
