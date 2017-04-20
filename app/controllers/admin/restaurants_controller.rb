class Admin::RestaurantsController < ApplicationController
  before_action :set_restaurant, only: [:edit, :update]

  def edit
    @restaurant_messenger_code = JSON.parse(RestClient.post(
      "https://graph.facebook.com/v2.6/me/messenger_codes?access_token=#{ENV['YVON_ACCESS_TOKEN']}",
      {
        type: "standard",
        data: {
          ref:"restaurant_#{@restaurant.id}"
        },
        image_size: 400
      }.to_json,
      {content_type: :json, accept: :json}
    ))['uri']

    @table_messenger_code = {}
    (1..12).each do |table_number|
      @table_messenger_code["table_#{table_number}"] = JSON.parse(RestClient.post(
      "https://graph.facebook.com/v2.6/me/messenger_codes?access_token=#{ENV['YVON_ACCESS_TOKEN']}",
      {
        type: "standard",
        data: {
          ref:"restaurant_#{@restaurant.id}_table_#{table_number}"
        },
        image_size: 400
      }.to_json,
      {content_type: :json, accept: :json}
    ))['uri']
    end
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
      flash[:notice] = "Mise à jour Deliveroo effectuée."
    else
      flash[:alert] = "Mise à jour Deliveroo impossible."
    end
    redirect_to edit_admin_restaurant_path(@restaurant)
  end

  def foodora_update
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize [:admin, @restaurant]

    if Restaurant::CreateMenuFromFoodora.new(@restaurant).call
      flash[:notice] = "Mise à jour Foodora effectuée."
    else
      flash[:alert] = "Mise à jour Foodora impossible."
    end
    redirect_to edit_admin_restaurant_path(@restaurant)
  end

  def ubereats_update
    @restaurant = Restaurant.find(params[:restaurant_id])
    authorize [:admin, @restaurant]

    if Restaurant::CreateMenuFromUbereats.new(@restaurant).call
      flash[:notice] = "Mise à jour UberEATS effectuée."
    else
      flash[:alert] = "Mise à jour UberEATS impossible."
    end
    redirect_to edit_admin_restaurant_path(@restaurant)
  end

  private

  def set_restaurant
    @restaurant = Restaurant.find(params[:id])
    authorize [:admin, @restaurant]
  end

  def restaurant_params
    params.require(:restaurant).permit(:user_id, :deliveroo_url, :foodora_url, :ubereats_url)
  end

end
