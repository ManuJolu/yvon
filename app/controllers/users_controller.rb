class UsersController < ApplicationController
  before_action :set_user, only: [:show, :credit_card_update]

  def show
    byebug
    @update = params[:update]
  end

  def credit_card_update
    if @user.stripe_customer_id.nil?
      customer = Stripe::Customer.create(
        source: params[:stripeToken],
        email:  params[:stripeEmail]
      )
      @user.update(
        stripe_customer_id: customer.id,
      )
    else
      customer = Stripe::Customer.retrieve(@user.stripe_customer_id)
      customer.source = params[:stripeToken]
      customer.save
    end
    customer = Stripe::Customer.retrieve(id: @user.stripe_customer_id, expand: ['default_source'])
    @user.update(
      stripe_default_source_brand: customer.default_source.brand,
      stripe_default_source_last4: customer.default_source.last4
    )
    redirect_to user_path(@user, update: 'cc')
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to @user
  end

  private

  def set_user
    @user = User.find(params[:id])
    authorize @user
  end
end
