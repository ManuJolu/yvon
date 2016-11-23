class MealsController < ApplicationController
  before_action :set_meal, only: [:show, :edit, :update]
  before_action :find_restaurant, only: [ :index, :new, :create, :update ]

  def index
    @meals = @restaurant.meals.all
  end

  def show
  end

  def new
    @meal = Meal.new
  end

  def create
    @meal = @restaurant.meals.new(meal_params)
    if @meal.save
      redirect_to @restaurant
    else
      render 'new'
    end
  end

  def edit
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

  def meal_params
    params.require(:meal).permit(:restaurant_id, :category, :name, :description, :price, :tax, :photo)
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

end
