class Admin::RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:edit, :update]

  def edit
  end

  def update
    if @restaurant.update(restaurant_params)
      respond_to do |format|
        format.html { redirect_to edit_admin_restaurant_path(@restaurant) }
      end
    else
      respond_to do |format|
        format.html { render :edit }
      end
    end
  end

  def deliveroo_update
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize [:admin, @restaurant]

    if Restaurant::CreateMenuFromDeliveroo.new(@restaurant).call
      flash[:notice] = "Mise à jour effectuée."
    else
      flash[:alert] = "Mise à jour impossible."
    end
    redirect_to edit_admin_restaurant_path(@restaurant)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize [:admin, @restaurant]
  end

  def restaurant_params
    params.require(:restaurant).permit(:user_id, :deliveroo_url)
  end

end
