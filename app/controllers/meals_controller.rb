class MealsController < ApplicationController
  before_action :set_meal, only: [:edit, :update, :destroy]
  before_action :set_restaurant, only: [:index, :new, :create]

  def index
    @meals = policy_scope(@restaurant.meals).order(:position)
  end

  def new
    @meal = @restaurant.meals.new
    @meal.meal_category = MealCategory.find(params[:meal_category_id])
    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @meals = @restaurant.meals.order(:position)
    @meal = @restaurant.meals.new(meal_params)
    if @meal.save
      respond_to do |format|
        format.html { redirect_to @meal }
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
    @restaurant = @meal.restaurant
    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    @restaurant = @meal.restaurant
    @meals = @restaurant.meals.order(:position)
    if @meal.update(meal_params)
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

  def destroy
    @restaurant = @meal.restaurant
    @meals = @restaurant.meals.order(:position)
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to @meals }
      format.js
    end
end

  private

  def set_meal
    @meal = Meal.find(params[:id])
    authorize @meal
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize @restaurant, :update?
  end

  def meal_params
    params.require(:meal).permit(
      :restaurant_id, :meal_category_id, :position, :name, :description, :price, :tax_rate, :photo, :active,
      meal_options_attributes: [:id, :_destroy, :option_id, option_attributes: [:id, :name, :restaurant_id, :_destroy]]
    )
  end
end
