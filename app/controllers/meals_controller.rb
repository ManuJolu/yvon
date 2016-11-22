class MealsController < ApplicationController
  before_action :set_meal, only: [:show, :edit, :update]

  def index
    @meals = Meals.all
  end

  def show
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @meal = @restaurant.meals.new(meal_params)
    if @meal.save
      redirect_to @meal
    else
      render 'new'
    end
  end

  def update
    @meal.update(meal_params)
    if meal.save
      redirect_to @meal
    else
      render 'edit'
    end
  end


  private


  def set_meal
    @meal = Meal.find(params[:id])
  end

  def meal_params
    params.require(:meal).permit(:restaurant_id, :category, :name, :description, :price, :tax, :photo)


end
