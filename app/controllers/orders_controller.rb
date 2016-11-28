class OrdersController < ApplicationController
  before_action :set_order, only: [:update]
  before_action :set_restaurant, only: [:update]

  def update
    if order_params[:ready_at]
      @order.ready_at = DateTime.now
      if @order.save
        if Rails.env.production?
          Facebook::Messenger::Bot.deliver({
            recipient: {
              id: @order.user.messenger_id
            },
            message: {
              text: "Hey #{@order.user.first_name}, your order at #{@order.restaurant.name} is ready for pick-up!"
            }},
            access_token: ENV['ACCESS_TOKEN']
          )
        end
        respond_to do |format|
          format.html { redirect_to restaurant_path(@restaurant) }
          format.js { }
        end
      else
        @meal = @restaurant.meals.new
        respond_to do |format|
          format.html { render 'restaurants/show' }
          format.js
        end
      end
    elsif order_params[:delivered_at]
      @order.update(delivered_at: Time.now)
      if @order.save
        if Rails.env.production?
          Facebook::Messenger::Bot.deliver({
            recipient: {
              id: @order.user.messenger_id
            },
            message: {
              text: "#{@order.user.first_name}, you picked up your order at #{@order.restaurant.name}. Can I help you for something else?",
              quick_replies: [
                {
                  content_type: 'location'
                }
              ]
            }},
            access_token: ENV['ACCESS_TOKEN']
          )
        end
        respond_to do |format|
          format.html { redirect_to restaurant_path(@restaurant) }
          format.js { }
        end
      else
        @meal = @restaurant.meals.new
        respond_to do |format|
          format.html { render 'restaurants/show' }
          format.js { }
        end
      end
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def set_restaurant
    @restaurant = @order.restaurant
  end

  def order_params
    params.require(:order).permit(:ready_at, :delivered_at)
  end

end


