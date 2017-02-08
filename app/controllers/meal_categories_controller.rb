class MealCategoriesController < ApplicationController
  before_action :set_meal_category, only: [:update]
  before_action :set_restaurant, only: [:create]

  def create
    @meal_category = @restaurant.meal_categories.new(meal_category_params)
    if @meal_category.save
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
    @restaurant = @meal_category.restaurant
    @meal_category.update(meal_category_params)
    if @meal_category.save
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

  def set_meal_category
    @meal_category = MealCategory.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def meal_category_params
    params.require(:meal_category).permit(:name, :timing, :position)
  end
end
