class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:edit, :update, :refresh, :duty, :preparation_time_update]
  skip_before_action :authenticate_user!, only: [ :index ]

  def index

    @restaurants = policy_scope(Restaurant).where.not(latitude: nil, longitude: nil)

    # @hash = Gmaps4rails.build_markers(@restaurants) do |restaurant, marker|
    #   marker.lat restaurant.latitude
    #   marker.lng restaurant.longitude
    #   # marker.infowindow render_to_string(partial: "/flats/map_box", locals: { flat: flat })
    # end
  end

  def new
    @restaurant = Restaurant.new
    authorize @restaurant
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    authorize @restaurant
    if @restaurant.save
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
    @active = params[:tab] || 'configure'
  end

  def update
    @restaurant.update(restaurant_params)
    if @restaurant.save
      respond_to do |format|
        format.html { redirect_to restaurant_orders_path(@restaurant) }
        format.js {
          ActionCable.server.broadcast "restaurant_#{@restaurant.id}",
            update: "restaurant"
        }
      end
    else
      @new_meal = @restaurant.meals.new
      respond_to do |format|
        format.html { render :show }
        format.js
      end
    end
  end

  def refresh
    @update = params[:update]
    respond_to do |format|
      format.js
    end
  end

  def duty
    @restaurant.on_duty = (params[:state] == "on" ? true : false)
    if @restaurant.save
      ActionCable.server.broadcast "restaurant_#{@restaurant.id}",
        update: "duty"
    end
  end

  def preparation_time_update
    @restaurant.update(restaurant_params)
    if @restaurant.save
      respond_to do |format|
        format.html { redirect_to restaurant_orders_path(@restaurant) }
        format.js {
          ActionCable.server.broadcast "restaurant_#{@restaurant.id}",
            update: "preparation_time"
        }
      end
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name, :slogan, :user_id, :restaurant_category_id, :address, :on_duty, :shift, :photo, :description, :preparation_time, :facebook_url, :mode,
      meal_categories_attributes: [:id, :name, :position, :timing, :_destroy],
      options_attributes: [:id, :name, :position, :_destroy],
      menus_attributes: [:id, :name, :price, :tax_rate, :position, :_destroy,
        menu_meal_categories_attributes:[:id, :menu_id, :meal_category_id, :quantity, :_destroy]
      ]
    )
  end

end
