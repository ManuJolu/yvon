class OrderDecorator < Draper::Decorator
  delegate_all
  decorates_association :user
  decorates_association :ordered_meals, scope: :by_category

  def price
    humanized_money_with_symbol object.price
  end

  def price_num
    humanized_money object.price
  end

  def tax_num
    humanized_money object.tax
  end

  def pretax_price_num
    humanized_money object.pretax_price
  end

  def alacarte_price_num
    humanized_money object.alacarte_price
  end

  def discount_num
    humanized_money object.discount
  end

  def paid_at
    object.paid_at&.strftime('%-H:%M:%S')
  end

  def ready_at
    object.ready_at&.strftime('%-H:%M:%S')
  end

  def delivered_at
    object.delivered_at&.strftime('%-H:%M:%S')
  end
end
