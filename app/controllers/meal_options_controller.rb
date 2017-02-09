class MealOptionsController < ApplicationController
  before_action :set_meal, only: [:index]

  def index
    @meal_options = @meal.meal_options
    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_meal
    @meal = Meal.find(params[:meal_id])
  end

end
