class PaymentsController < ApplicationController
before_action :set_order, only: [:new, :create]

  def new
    @order
  end

  def create
    customer_id = @order.user.stripe_customer_id
    unless customer_id
      customer = Stripe::Customer.create(
        source: params[:stripeToken],
        email:  params[:stripeEmail]
      )
      @order.user.update(stripe_customer_id: customer.id)
      customer_id = customer.id
    end

    charge = Stripe::Charge.create(
      customer:     customer_id,
      amount:       @order.price_cents,
      description:  "Payment for order #{@order.id} at #{@order.restaurant.name}",
      currency:     @order.price.currency
    )

    @order.update(payment: charge.to_json, state: :paid)
    redirect_to root_path

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_payment_path(@order)
  end

private

  def set_order
    @order = Order.where(state: :pending).find(params[:order_id])
    authorize @order, :pay?
  end
end
