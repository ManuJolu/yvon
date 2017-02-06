class MealsController < ApplicationController
  before_action :set_meal, only: [:update]
  before_action :set_restaurant, only: [:create, :update]

  def create
    @meal = @restaurant.meals.new(meal_params)
    if @meal.save
      respond_to do |format|
        format.html { redirect_to @restaurant }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end
  end

  def update
    @meal = Meal.find(params[:id])
    @meal.update(meal_params)
    if @meal.save
      respond_to do |format|
        format.html { redirect_to @restaurant }
        format.js
      end
    else
      respond_to do |format|
        format.html { render :edit }
        format.js
      end
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
    params.require(:meal).permit(:restaurant_id, :category, :meal_category_id, :name, :description, :price, :tax_rate, :photo, :active)
  end

end
