class MealsController < ApplicationController
  before_action :set_meal, only: [:edit, :update]
  before_action :set_restaurant, only: [:index, :create]

  def index
    @meals = @restaurant.meals.order(:position)
  end

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

  def edit
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @restaurant = @meal.restaurant
    @meals = @restaurant.meals.order(:position)
    @meal.update(meal_params)
    if @meal.save
      respond_to do |format|
        format.html { redirect_to @meal }
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
    params.require(:meal).permit(:restaurant_id, :meal_category_id, :position, :name, :description, :price, :tax_rate, :photo, :active)
  end
end
