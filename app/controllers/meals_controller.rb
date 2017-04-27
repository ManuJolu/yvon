class MealsController < ApplicationController
  before_action :set_meal, only: [:edit, :update, :destroy]
  before_action :set_restaurant, only: [:new, :create]

  def index
    @restaurant = policy_scope(Restaurant.includes(meal_categories: [ :mobility_string_translations, { meals: [ { options: :mobility_string_translations }, :photo_files, :mobility_string_translations ] }]).find(params[:restaurant_id]))
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
    @meal.destroy
    respond_to do |format|
      format.html { redirect_to @meals }
      format.js
    end
end

  private

  def set_meal
    @meal = Meal.includes(:mobility_string_translations).find(params[:id])
    authorize @meal
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize @restaurant, :update?
  end

  def meal_params
    params.require(:meal).permit(
      :meal_category_id, :position, :name, :name_fr, :name_en, :description, :description_fr, :description_en, :price, :tax_rate, :photo, :active, option_ids: []
    )
  end
end
