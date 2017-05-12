class MealCategoriesController < ApplicationController
  before_action :set_meal_category, only: [:update]

  def update
    @restaurant = @meal_category.restaurant
    if @meal_category.update(meal_category_params)
      respond_to do |format|
        format.html { redirect_to restaurant_meals_path(@restaurant) }
        format.js
      end
    # else
    #   respond_to do |format|
    #     format.html { redirect_to restaurant_meals_path(@restaurant) }
    #     format.js
    #   end
    end
  end

  private

  def set_meal_category
    @meal_category = MealCategory.find(params[:id])
    authorize @meal_category
  end

  def meal_category_params
    params.require(:meal_category).permit(:active)
  end
end
