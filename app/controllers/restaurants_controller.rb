class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:edit, :update, :duty_update, :preparation_time_update, :facebook_update, :refresh]
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
    if Restaurant::UpdateFromFacebook.new(@restaurant).call
      flash[:alert] = nil
      respond_to do |format|
        format.html { redirect_to edit_restaurant_path(@restaurant, tab: 'configure') }
        format.js
      end
    else
      flash[:alert] = "Mise à jour impossible, vérifiez votre adresse de page Facebook."
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
    if @restaurant.update(restaurant_params)
      respond_to do |format|
        format.html { redirect_to restaurant_orders_path(@restaurant) }
        format.js {
          ActionCable.server.broadcast "restaurant_#{@restaurant.id}",
            update: "restaurant"
        }
      end
    else
      @update = "restaurant"
      respond_to do |format|
        format.html { render :edit }
        format.js { render :refresh }
      end
    end
  end

  def duty_update
    @restaurant.on_duty = (params[:state] == "on" ? true : false)
    if @restaurant.save
      BotAline::NotificationsController.new.notify_duty(@restaurant)
      ActionCable.server.broadcast "restaurant_#{@restaurant.id}",
        update: "duty"
    end
  end

  def preparation_time_update
    if @restaurant.update(restaurant_params)
      BotAline::NotificationsController.new.notify_preparation_time(@restaurant)
      respond_to do |format|
        format.html { redirect_to restaurant_orders_path(@restaurant) }
        format.js {
          ActionCable.server.broadcast "restaurant_#{@restaurant.id}",
            update: "preparation_time"
        }
      end
    end
  end

  def facebook_update
    if Restaurant::UpdateFromFacebook.new(@restaurant).call
      flash[:notice] = "Mise à jour effectuée."
    else
      flash[:alert] = "Mise à jour impossible, vérifiez votre adresse de page Facebook."
    end
      redirect_to edit_restaurant_path(@restaurant, tab: 'configure')
  end

  def refresh
    @update = params[:update]
    respond_to do |format|
      format.js
    end
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize @restaurant
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name, :about, :user_id, :restaurant_category_id, :address, :on_duty, :shift, :photo, :description, :preparation_time, :facebook_url, :mode, :messenger_pass,
      meal_categories_attributes: [:id, :name, :position, :timing, :_destroy],
      options_attributes: [:id, :active, :name, :position, :_destroy],
      menus_attributes: [:id, :name, :price, :tax_rate, :position, :_destroy,
        menu_meal_categories_attributes:[:id, :menu_id, :meal_category_id, :quantity, :_destroy]
      ]
    )
  end

end
