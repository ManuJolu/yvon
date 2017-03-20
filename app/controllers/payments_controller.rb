class PaymentsController < ApplicationController
before_action :set_order, only: [:new, :create]

  def new
    redirect_to @order unless @order.pending?
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

    @order.update(payment: charge.to_json, payment_method: :credit_card)
    redirect_to @order

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_order_payment_path(@order)
  end

private

  def set_order
    @order = Order.find(params[:order_id])
    authorize @order, :show?
  end
end
